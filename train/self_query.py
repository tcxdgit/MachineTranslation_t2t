# coding=utf-8
# Copyright 2018 The Tensor2Tensor Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Query an exported model. Install tensorflow-serving-api."""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from oauth2client.client import GoogleCredentials
from six.moves import input  # pylint: disable=redefined-builtin

from tensor2tensor import problems as problems_lib  # pylint: disable=unused-import
from tensor2tensor.serving import serving_utils
from tensor2tensor.utils import registry
from tensor2tensor.utils import usr_dir
import tensorflow as tf
import jieba
import os
import re
import unicodedata

import logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(filename)s[%(lineno)d] - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# load jieba model
# 自定义领域词典
user_dict = '../data/userdict.txt'
if os.path.exists(user_dict):
    print('Load user vocabulary for word cut:  {} '.format(user_dict))
    jieba.load_userdict(user_dict)
jieba.cut('')

flags = tf.flags
FLAGS = flags.FLAGS

flags.DEFINE_string("server", None, "Address to Tensorflow Serving server.")
flags.DEFINE_string("servable_name", None, "Name of served model.")
flags.DEFINE_string("problem", None, "Problem name.")
flags.DEFINE_string("data_dir", None, "Data directory, for vocab files.")
flags.DEFINE_string("t2t_usr_dir", None, "Usr dir for registrations.")
flags.DEFINE_string("inputs_once", None, "Query once with this input.")
flags.DEFINE_integer("timeout_secs", 10, "Timeout for query.")
flags.DEFINE_boolean("word_cut", True, "Weather use word cut.")

# For Cloud ML Engine predictions.
flags.DEFINE_string("cloud_mlengine_model_name", None,
                    "Name of model deployed on Cloud ML Engine.")
flags.DEFINE_string(
    "cloud_mlengine_model_version", None,
    "Version of the model to use. If None, requests will be "
    "sent to the default version.")


def validate_flags():
  """Validates flags are set to acceptable values."""
  if FLAGS.cloud_mlengine_model_name:
    assert not FLAGS.server
    assert not FLAGS.servable_name
  else:
    assert FLAGS.server
    assert FLAGS.servable_name


def make_request_fn():
  """Returns a request function."""
  if FLAGS.cloud_mlengine_model_name:
    request_fn = serving_utils.make_cloud_mlengine_request_fn(
        credentials=GoogleCredentials.get_application_default(),
        model_name=FLAGS.cloud_mlengine_model_name,
        version=FLAGS.cloud_mlengine_model_version)
  else:

    request_fn = serving_utils.make_grpc_request_fn(
        servable_name=FLAGS.servable_name,
        server=FLAGS.server,
        timeout_secs=FLAGS.timeout_secs)
  return request_fn

# def translation(inputs):
#     logger.info('translate sents:{}'.format(inputs))
#
#     outputs = serving_utils.predict(inputs, problem, request_fn)
#     outputs = ''.join(result for result,score in outputs)
#     outputs = outputs.replace('< / EOP >', '\r\n')
#   # return (print_str.format(inputs=input, output=output, score=score))
#     return outputs


def preprocess(text):
    msg = unicodedata.normalize('NFKC', text)
    msg = msg.strip()
    return msg


def postprocess(text):
    res = unicodedata.normalize('NFKC', text)
    res = re.sub(" {2,}", " ", res)
    res = re.sub(" ,", ",", res)
    res = re.sub("’", "'", res)
    res = re.sub("“ ", "\"", res)
    res = re.sub("' ", "'", res)
    res = re.sub(" '", "'", res)
    res = re.sub(" ”", "\"", res)
    res = re.sub("‘ ", "'", res)
    res = re.sub(" _ ", "_", res)
    res = re.sub(" :", ":", res)
    res = re.sub(" / ", "/", res)
    res = re.sub(" — ", "—", res)
    res = re.sub("\( ", "(", res)
    res = re.sub(" \)", ")", res)
    res = re.sub("< ", "<", res)
    res = re.sub(" >", ">", res)
    res = re.sub("\$ ", "$", res)
    res = re.sub(" \.", ". ", res)

    return res


def main(_):
  tf.logging.set_verbosity(tf.logging.INFO)
  validate_flags()
  usr_dir.import_usr_dir(FLAGS.t2t_usr_dir)
  problem = registry.problem(FLAGS.problem)
  hparams = tf.contrib.training.HParams(
      data_dir=os.path.expanduser(FLAGS.data_dir))
  problem.get_hparams(hparams)
  request_fn = make_request_fn()
  while True:
    inputs = FLAGS.inputs_once if FLAGS.inputs_once else input(">> ")
    inputs = preprocess(inputs)
    if FLAGS.word_cut:
        inputs = " ".join(jieba.cut(inputs))
    outputs = serving_utils.predict([inputs], problem, request_fn)
    outputs, = outputs
    output, score = outputs

    output = postprocess(output)

    print_str = """
Input:
{inputs}

Output (Score {score:.3f}):
{output}
    """
    print(print_str.format(inputs=inputs, output=output, score=score))
    if FLAGS.inputs_once:
        break


if __name__ == "__main__":
    flags.mark_flags_as_required(["problem", "data_dir"])
    tf.app.run()
