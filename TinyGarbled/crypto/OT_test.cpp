/*
 This file is part of TinyGarble. It is modified version of JustGarble
 under GNU license.

 TinyGarble is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 TinyGarble is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with TinyGarble.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "crypto/OT.h"

#include <openssl/rand.h>
#include <iostream>
#include "tcpip/tcpip.h"
#include "tcpip/tcpip_testsuit.h"
#include "util/common.h"
#include "util/util.h"
#include "util/log.h"

using std::endl;

struct OTTestStruct {
  block** message;
  bool* select;
  uint len;
};

int Alice(const void* data, int connfd) {
  OTTestStruct* OT_test_str = (OTTestStruct*) data;
  block **message = OT_test_str->message;
  uint len = OT_test_str->len;
  if (OTSend(message, len, connfd) == FAILURE) {
    LOG(ERROR) << "OTsend failed." << endl;
    return FAILURE;
  }
  return SUCCESS;
}

int Bob(const void *data, int connfd) {
  OTTestStruct* OT_test_str = (OTTestStruct*) data;
  block **message = OT_test_str->message;
  bool *select = OT_test_str->select;
  uint len = OT_test_str->len;
  block* message_recv = new block[len];

  if (OTRecv(select, len, connfd, message_recv) == FAILURE) {
    LOG(ERROR) << "OTsend failed." << endl;
    return FAILURE;
  }

  bool test_passed = true;
  for (uint i = 0; i < len; i++) {
    if (!CmpBlock(message[i][(select[i] ? 1 : 0)], message_recv[i])) {
      LOG(ERROR) << "Equality test failed." << endl << message_recv[i] << "!="
          << message[i][select[i] ? 1 : 0] << endl;
      test_passed = false;
    }
  }

  delete[] message_recv;
  if (!test_passed) {
    return FAILURE;
  } else {
    LOG(INFO) << "Equality test Passed." << endl;
  }
  return SUCCESS;
}

int main(int argc, char* argv[]) {

  LogInitial(argc, argv);

  srand(time(NULL));
  SrandSSE(time(NULL));
  uint len = rand() % 5 + 5;
  LOG(INFO) << "Run OT 1 from 2 on a vector with size " << len << endl;
  block** message = new block*[len];
  bool* select = new bool[len];
  for (uint i = 0; i < len; i++) {
    message[i] = new block[2];
    for (uint j = 0; j < 2; j++) {
      message[i][j] = RandomBlock();
    }
    select[i] = (rand() % 2 == 1);
  }

  OTTestStruct OT_test_str;
  OT_test_str.message = message;
  OT_test_str.select = select;
  OT_test_str.len = len;

  if (TcpipTestRun(Alice, (void *) &OT_test_str, Bob,
                   (void *) &OT_test_str) == FAILURE) {
    LOG(ERROR) << "tcpip test run failed." << endl;
    return FAILURE;
  }

  for (uint i = 0; i < len; i++) {
    delete[] message[i];
  }
  delete[] message;
  delete[] select;

  LogFinish();
  return SUCCESS;
}

