/*
 This file is part of JustGarble.

 JustGarble is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 JustGarble is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with JustGarble.  If not, see <http://www.gnu.org/licenses/>.

 */
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

#ifndef GARBLED_CIRCUIT_GARBLED_CIRCUIT_H_
#define GARBLED_CIRCUIT_GARBLED_CIRCUIT_H_

#include <cstdint>
#include <string>
#include <openssl/bn.h>
#include "crypto/block.h"

using std::string;

/**
 * @brief Used to store two labels.
 */
typedef struct BlockPair {
  block label0;
  block label1;
} BlockPair;

/**
 * @brief Used to store inputs, output, and type of gate in the circuit.
 *
 */
typedef struct GarbledGate {
  int64_t input0; /**< wire index for 1st input. */
  int64_t input1; /**< wire index for 2st input. */
  int64_t output; /**< wire index for output. */
  int type; /**< wire Type, defined in util/common.h */
} GarbledGate;

/**
 * @brief Stores Garbled Circuit.
 *
 * GarbledCircuit structure stores all the information required
 * for both garbling and evaluation. It is created based on SCD file.
 */
typedef struct GarbledCircuit {
  uint64_t g_init_size;
  uint64_t e_init_size;
  uint64_t g_input_size;
  uint64_t e_input_size;
  uint64_t dff_size;
  uint64_t output_size;
  uint64_t gate_size;

  GarbledGate* garbledGates; /*!< topologically sorted gates */
  int64_t *outputs; /*!< index of output wires */
  int64_t *D; /*!< p-length array of wire index corresponding
   to D signal (Data) of DFF. */
  int64_t *I; /*!< p-length array of wire index corresponding
   to I signal (Initial) of DFF. */

  inline uint64_t get_init_size() const {
    return g_init_size + e_init_size;
  }
  inline uint64_t get_input_size() const {
    return g_input_size + e_input_size;
  }
  inline uint64_t get_wire_size() const {
    return get_init_size() + get_input_size() + dff_size + gate_size;
  }

  /**
   * indexing structure:
   * 0.g_init
   * 1.e_init
   * 2.g_input
   * 3.e_input
   * 4.dff
   * 5.gate
   */
  inline uint64_t get_init_lo_index() const {
    return 0;
  }
  inline uint64_t get_g_init_lo_index() const {
    return 0;
  }
  inline uint64_t get_g_init_hi_index() const {
    return g_init_size;
  }

  inline uint64_t get_e_init_lo_index() const {
    return get_g_init_hi_index();
  }
  inline uint64_t get_e_init_hi_index() const {
    return get_g_init_hi_index() + e_init_size;
  }
  inline uint64_t get_init_hi_index() const {
    return get_e_init_hi_index();
  }

  inline uint64_t get_input_lo_index() const {
    return get_e_init_hi_index();
  }
  inline uint64_t get_g_input_lo_index() const {
    return get_e_init_hi_index();
  }
  inline uint64_t get_g_input_hi_index() const {
    return get_e_init_hi_index() + g_input_size;
  }

  inline uint64_t get_e_input_lo_index() const {
    return get_g_input_hi_index();
  }
  inline uint64_t get_e_input_hi_index() const {
    return get_g_input_hi_index() + e_input_size;
  }
  inline uint64_t get_input_hi_index() const {
    return get_e_input_hi_index();
  }

  inline uint64_t get_dff_lo_index() const {
    return get_e_input_hi_index();
  }
  inline uint64_t get_dff_hi_index() const {
    return get_e_input_hi_index() + dff_size;
  }

  inline uint64_t get_gate_lo_index() const {
    return get_dff_hi_index();
  }
  inline uint64_t get_gate_hi_index() const {
    return get_dff_hi_index() + gate_size;
  }

  inline uint64_t get_wire_lo_index() const {
    return 0;
  }
  inline uint64_t get_wire_hi_index() const {
    return get_gate_hi_index();
  }

} GarbledCircuit;

int OutputBN2Str(const GarbledCircuit& garbled_circuit, BIGNUM* outputs,
                 uint64_t clock_cycles, int output_mode, string *output_str);

int GarbleStr(const string& scd_file_address, const string& init_str,
              const string& input_str, uint64_t clock_cycles,
              const string& output_mask, int output_mode, bool disable_OT,
              bool low_mem_foot, string* output_str, int connfd);
int EvaluateStr(const string& scd_file_address, const string& init_str,
                const string& input_str, uint64_t clock_cycles,
                const string& output_mask, int output_mode, bool disable_OT,
                bool low_mem_foot, string* output_str, int connfd);

#endif /* GARBLED_CIRCUIT_GARBLED_CIRCUIT_H_ */
