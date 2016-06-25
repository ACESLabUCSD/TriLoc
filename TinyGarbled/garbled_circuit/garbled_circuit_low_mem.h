/*
 * garbled_circuit_low_mem.h
 *
 *  Created on: Oct 26, 2015
 *      Author: ebi
 */

#ifndef GARBLED_CIRCUIT_GARBLED_CIRCUIT_LOW_MEM_H_
#define GARBLED_CIRCUIT_GARBLED_CIRCUIT_LOW_MEM_H_

#include <openssl/bn.h>
#include "garbled_circuit/garbled_circuit.h"
#include "crypto/aes.h"

uint64_t GarbleLowMem(const GarbledCircuit& garbled_circuit,
                      block* const_labels, block* init_labels,
                      block* input_labels, block* garbled_tables, block R,
                      AES_KEY& AES_Key, uint64_t cid, int connfd,
                      BlockPair *wires, block* output_labels);
uint64_t EvaluateLowMem(const GarbledCircuit& garbled_circuit,
                        block* const_labels, block* init_labels,
                        block* input_labels, block* garbled_tables,
                        AES_KEY& AES_Key, uint64_t cid, int connfd,
                        block *wires, block* output_labels);

int GarbleAllocLabels(const GarbledCircuit& garbled_circuit,
                      block** const_labels, block** init_labels,
                      block** input_labels, block** output_labels, block R);
int GarbleGneInitLabels(const GarbledCircuit& garbled_circuit,
                        block* const_labels, block* init_labels, block R);
int GarbleGenInputLabels(const GarbledCircuit& garbled_circuit,
                         block* input_labels, block R);

int EvaluateAllocLabels(const GarbledCircuit& garbled_circuit,
                        block** const_labels, block** init_labels,
                        block** input_labels, block** output_labels);

int GarbleTransferInitLabels(const GarbledCircuit& garbled_circuit,
                             block* const_labels, BIGNUM* g_init,
                             block* init_labels, bool disable_OT, int connfd);
int GarbleTransferInputLabels(const GarbledCircuit& garbled_circuit,
                              BIGNUM* g_input, block* input_labels,
                              uint64_t cid, bool disable_OT, int connfd);

int EvaluateTransferInitLabels(const GarbledCircuit& garbled_circuit,
                               block* const_labels, BIGNUM* e_init,
                               block* init_labels, bool disable_OT, int connfd);
int EvaluateTransferInputLabels(const GarbledCircuit& garbled_circuit,
                                BIGNUM* e_input, block* input_labels,
                                uint64_t cid, bool disable_OT, int connfd);

int OutputBN2StrLowMem(const GarbledCircuit& garbled_circuit, BIGNUM* outputs,
                       uint64_t clock_cycles, int output_mode,
                       string* output_str);
int GarbleTransferOutputLowMem(const GarbledCircuit& garbled_circuit,
                               block* output_labels, uint64_t cid,
                               int output_mode, const string& output_mask,
                               BIGNUM* output_bn, int connfd);
int EvaluateTransferOutputLowMem(const GarbledCircuit& garbled_circuit,
                                 block* output_labels, uint64_t cid,
                                 int output_mode, const string& output_mask,
                                 BIGNUM* output_bn, int connfd);

#endif /* GARBLED_CIRCUIT_GARBLED_CIRCUIT_LOW_MEM_H_ */
