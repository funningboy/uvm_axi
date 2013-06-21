`ifndef TTUE
  `define TRUE 1
`endif

`ifndef FALSE
  `define FALSE 0
`endif


`define delay(d) \
  #d;

typedef enum { TERAWINS_AXI_DDR, VIRTUAL_SLAVE }              slave_type_enum;
typedef enum { VIRTUAL_MASTER }                               master_type_enum;

typedef enum { MASTER = 0, SLAVE = 1 }                        itype_enum;

typedef enum { READ = 0, WRITE = 1 }                          direction_enum;

function dec_direction(int unsigned d);
  case(d)
    0 : return READ;
    1 : return WRITE;
    default : `uvm_error("NODIRECT",{$psprintf("direct %d must be set for: [0:1]", d)})
  endcase
endfunction : dec_direction

typedef enum { FIXED = 0, INCR = 1, WRAP = 2, RESERVED_BURST = 3 }  burst_enum;

function burst_enum dec_burst(int unsigned b);
  case(b)
    0 : return FIXED;
    1 : return INCR;
    2 : return WRAP;
    3 : return RESERVED_BURST;
    default : `uvm_error("NOBURST", {$psprintf("burst %d must be set for [0:3]", b)})
  endcase
endfunction : dec_burst

typedef enum { BYTE_1 = 0,
               BYTE_2 = 1,
               BYTE_4 = 2,
               BYTE_8 = 3,
               BYTE_16 = 4,
               BYTE_32 = 5,
               BYTE_64 = 6,
               BYTE_128 = 7 }                                 byte_enum;

function byte_enum dec_byte(int unsigned b);
  case(b)
    0 : return BYTE_1;
    1 : return BYTE_2;
    2 : return BYTE_4;
    3 : return BYTE_8;
    4 : return BYTE_16;
    5 : return BYTE_32;
    6 : return BYTE_64;
    7 : return BYTE_128;
    default : `uvm_error("NOBYTE", {$psprintf("byte %d must be set for [0:7]", b)})
  endcase
endfunction : dec_byte

typedef enum { LEN_1 = 0,
               LEN_2 = 1,
               LEN_3 = 2,
               LEN_4 = 3,
               LEN_5 = 4,
               LEN_6 = 5,
               LEN_7 = 6,
               LEN_8 = 7,
               LEN_9 = 8,
               LEN_10 = 9,
               LEN_11 = 10,
               LEN_12 = 11,
               LEN_13 = 12,
               LEN_14 = 13,
               LEN_15 = 14,
               LEN_16 = 15,
               LEN_17 = 16,
               LEN_18 = 17,
               LEN_19 = 18,
               LEN_20 = 19,
               LEN_21 = 20,
               LEN_22 = 21,
               LEN_23 = 22,
               LEN_24 = 23,
               LEN_25 = 24,
               LEN_26 = 25,
               LEN_27 = 26,
               LEN_28 = 27,
               LEN_29 = 28,
               LEN_30 = 29,
               LEN_31 = 30,
               LEN_32 = 31  }                                 len_enum;

function len_enum dec_len(int unsigned l);
  case(l)
    0 : return LEN_1;
    1 : return LEN_2;
    2 : return LEN_3;
    3 : return LEN_4;
    4 : return LEN_5;
    5 : return LEN_6;
    6 : return LEN_7;
    7 : return LEN_8;
    8 : return LEN_9;
    9 : return LEN_10;
    10 : return LEN_11;
    11 : return LEN_12;
    12 : return LEN_13;
    13 : return LEN_14;
    14 : return LEN_15;
    15 : return LEN_16;
    16 : return LEN_17;
    17 : return LEN_18;
    18 : return LEN_19;
    19 : return LEN_20;
    20 : return LEN_21;
    21 : return LEN_22;
    22 : return LEN_23;
    23 : return LEN_24;
    24 : return LEN_25;
    25 : return LEN_26;
    26 : return LEN_27;
    27 : return LEN_28;
    28 : return LEN_29;
    29 : return LEN_30;
    30 : return LEN_31;
    31 : return LEN_32;
    default : `uvm_error("NOBYTE", {$psprintf("len %d must be set for [0:31]", l)})
  endcase
endfunction : dec_len

// cache dec seq is followed [WA, RA, C, B]
// WA : (Write Allocate) = ARCACHE[3] and AWCACHE[3]
// RA : (Read Allocate)  = ARCACHE[2] and AWCACHE[2]
// C  : (Cacheable)      = ARCACHE[1] and AWCACHE[1]
// B  : (Bufferable)     = ARCACHE[0] and AWCACHE[0]
typedef enum { NONCACHEABLE_AND_NONBUFFERABLE        = 0,
               BUFFER_ONLY                           = 1,
               CACHEABLE_NOT_ALLOCATE                = 2,
               CACHEABLE_AND_BUFFERABLE_NOT_ALLOCATE = 3,
               RESERVED_4                            = 4,
               RESERVED_5                            = 5,
               CACHEABLE_WRITE_THROUGH_ALLOCATE_ON_READ_ONLY = 6,
               CACHEABLE_WRITE_BACK_ALLOCATE_ON_READ_ONLY = 7,
               RESERVED_8                            = 8,
               RESERVED_9                            = 9,
               CACHEABLE_WRITE_THROUGH_ALLOCATE_ON_WRITE_ONLY = 10,
               CACHEABLE_WRITE_BACK_ALLOCATE_ON_WRITE_ONLY = 11,
               RESERVED_12                           = 12,
               RESERVED_13                           = 13,
               CACHEABLE_WRITE_THROUGH_ALLOCATE_ON_READ_WRITE = 14,
               CACHEABLE_WRITE_BACK_ALLOCATE_ON_READ_WRITE = 15 } cache_dec_enum;

// cache enc seq is followed by WA, RA, C, B
typedef enum {  WA0_RA0_C0_B0                        = 0,
                WA0_RA0_C0_B1                        = 1,
                WA0_RA0_C1_B0                        = 2,
                WA0_RA0_C1_B1                        = 3,
                WA0_RA1_C0_B0                        = 4,
                WA0_RA1_C0_B1                        = 5,
                WA0_RA1_C1_B0                        = 6,
                WA0_RA1_C1_B1                        = 7,
                WA1_RA0_C0_B0                        = 8,
                WA1_RA0_C0_B1                        = 9,
                WA1_RA0_C1_B0                        = 10,
                WA1_RA0_C1_B1                        = 11,
                WA1_RA1_C0_B0                        = 12,
                WA1_RA1_C0_B1                        = 13,
                WA1_RA1_C1_B0                        = 14,
                WA1_RA1_C1_B1                        = 15 } cache_enc_enum;

function cache_enc_enum dec_cache(int unsigned b);
  case(b)
    0 : return WA0_RA0_C0_B0;
    1 : return WA0_RA0_C0_B1;
    2 : return WA0_RA0_C1_B0;
    3 : return WA0_RA0_C1_B1;
    4 : return WA0_RA1_C0_B0;
    5 : return WA0_RA1_C0_B1;
    6 : return WA0_RA1_C1_B0;
    7 : return WA0_RA1_C1_B1;
    8 : return WA1_RA0_C0_B0;
    9 : return WA1_RA0_C0_B1;
    10 : return WA1_RA0_C1_B0;
    11 : return WA1_RA0_C1_B1;
    12 : return WA1_RA1_C0_B0;
    13 : return WA1_RA1_C0_B1;
    14 : return WA1_RA1_C1_B0;
    15 : return WA1_RA1_C1_B1;
    default : `uvm_error("NOCACHE", {$psprintf("cache %d must be set for [0:15]", b)})
  endcase
endfunction : dec_cache

// protection dec seq is flollowed below
// NORMAL_OR_PRIVILEGED = ARPROT[0] and AWPROT[0]
// SECURE_OR_NONSECURE  = ARPROT[1] and AWPROT[1]
// INSTRUCTION_OR_DATA  = ARPROT[2] and ARPROT[2]
typedef enum {
                NORMAL_OR_PRIVILEGED                 = 0,
                SECURE_OR_NONSECURE                  = 1,
                INSTRUCTION_OR_DATA                  = 2 } protect_dec_enum;

// protection dec seq is followd below
typedef enum {
            PROT000                                  = 0,
            PROT001                                  = 1,
            PROT010                                  = 2,
            PROT011                                  = 3,
            PROT100                                  = 4,
            PROT101                                  = 5,
            PROT110                                  = 6,
            PROT111                                  = 7 } protect_enc_enum;

function protect_enc_enum dec_prot(int unsigned p);
  case(p)
    0: return PROT000;
    1: return PROT001;
    2: return PROT010;
    3: return PROT011;
    4: return PROT100;
    5: return PROT101;
    6: return PROT110;
    7: return PROT111;
    default : `uvm_error("NOPROTECT", {$psprintf("protect %d must be set for [0:7]", p)})
  endcase
endfunction : dec_prot

typedef enum {
            NORMAL_ACCESS                            = 0,
            EXCLUSIVE_ACCESS                         = 1,
            LOCKED_ACCESS                            = 2,
            RESERVED_ACCESS                          = 3 } lock_enum;

function lock_enum dec_lock(int unsigned l);
  case(l)
    0: return NORMAL_ACCESS;
    1: return EXCLUSIVE_ACCESS;
    2: return LOCKED_ACCESS;
    3: return RESERVED_ACCESS;
    default : `uvm_error("NOPROTECT", {$psprintf("lock %d must be set for [0:3]", l)})
  endcase
endfunction : dec_lock

typedef enum {
            OKAY                                     = 0,
            EXOKAY                                   = 1,
            SLVERR                                   = 2,
            DECERR                                   = 3 } response_enum;

function response_enum dec_resp(int unsigned r);
  case(r)
    0: return OKAY;
    1: return EXOKAY;
    2: return SLVERR;
    3: return DECERR;
    default : `uvm_error("NORESPONSE", {$psprintf("response %d must be set for [0:3]", r)})
  endcase
endfunction : dec_resp

function int unsigned dec_qos(int unsigned q);

  if ($isunknown(q))
    `uvm_error("NOQOS", {$psprintf("qos %s must be set for int", q)})

  return q;
endfunction : dec_qos

function int unsigned dec_addr(int unsigned a);

  if ($isunknown(a))
    `uvm_error("NOADDR", {$psprintf("addr %s must be set for int", a)})

  return a;
endfunction : dec_addr

function int unsigned dec_data(int unsigned d);

  if ($isunknown(d))
    `uvm_error("NODATA", {$psprintf("data %s must be set for int", d)})

  return d;
endfunction : dec_data

function int unsigned dec_id(int unsigned i);

  if ($isunknown(i))
    `uvm_error("NOID", {$psprintf("id %s must be set for int", i)})

  return i;
endfunction : dec_id

function int unsigned dec_region(int unsigned r);

  if ($isunknown(r))
    `uvm_error("NOREGION", {$psprintf("region %s must be set for int", r)})

  return r;
endfunction : dec_region

function int unsigned dec_strb(int unsigned s);

  if ($isunknown(s))
    `uvm_error("NOSTRB", {$psprintf("strb %s must be set for int", s)})

  return s;
endfunction : dec_strb
