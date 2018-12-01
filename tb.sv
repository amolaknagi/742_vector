`default_nettype none

`define WORD_SIZE  4
`define IMEM_WORDS (1024/`WORD_SIZE)
`define DMEM_WORDS (1024/`WORD_SIZE)


module TB;

  logic clk, rst_n;
  
  logic instr_req_o, instr_gnt_i, instr_rvalid_i;
  logic [31:0] instr_addr_o, instr_rdata_i;
  
  //input logic [N_EXT_PERF_COUNTERS-1:0] ext_perf_counters_i


  i_mem instruction_data(.clk, .rst_n,
                         .addr(instr_addr_o),
                         .req(instr_req_o),
                         .d_out(instr_rdata_i),
                         .grant(instr_gnt_i),
                         .valid(instr_rvalid_i));



   // Data memory interface
  logic        data_req_o, data_gnt_i, data_rvalid_i, data_we_o;
  logic [3:0]  data_be_o;
  logic [31:0] data_addr_o;
  logic [31:0] data_wdata_o;
  logic [31:0] data_rdata_i;
  logic        data_err_i;

  d_mem data_memory(.clk, .rst_n,
                    .addr(data_addr_o),
                    .req(data_req_o),
                    .we(data_we_o),
                    .be(data_be_o),
                    .d_in(data_wdata_o),
                    .d_out(data_rdata_i),
                    .grant(data_gnt_i),
                    .valid(data_rvalid_i),
                    .err(data_err_i));
  
                                        
  zeroriscy_core #(.N_EXT_PERF_COUNTERS(1), .RV32E(0), .RV32M(1))
  (
   // Clock and Reset
   .clk_i(clk),
   .rst_ni(rst_n),

   .clock_en_i(1'b1), // enable clock, otherwise it is gated
   //TODO: what the heck is this?
   .test_en_i(1'b0), // enable all clock gates for testing

  // Core ID, Cluster ID and boot address are considered more or less static
   .core_id_i(4'h0),
   .cluster_id_i(6'h0),
   .boot_addr_i(32'h0),

   
  // Instruction memory interface
   .instr_req_o,
   .instr_gnt_i,
   .instr_rvalid_i,
   .instr_addr_o,
   .instr_rdata_i,

  
  // Data memory interface
   .data_req_o,
   .data_gnt_i,
   .data_rvalid_i,
   .data_we_o,
   .data_be_o,
   .data_addr_o,
   .data_wdata_o,
   .data_rdata_i,
   .data_err_i,
    

   // Interrupt inputs
   .irq_i(1'b0), // level sensitive IR lines
   .irq_id_i(5'h0),
   .irq_ack_o(), // irq ack
   .irq_id_o(),

  // Debug Interface
   .debug_req_i(1'b0),
   .debug_gnt_o(),
   .debug_rvalid_o(),
   .debug_addr_i(15'h0),
   .debug_we_i(1'b0),
   .debug_wdata_i(32'h0),
   .debug_rdata_o(),
   .debug_halted_o(),
   .debug_halt_i(1'b0),
   .debug_resume_i(1'b0),

  // CPU Control Signals
   .fetch_enable_i(1'b1),

   .ext_perf_counters_i()
   );

  initial begin
    clk  = 1'b0;
    rst_n      <= 1'b0;
    #100 rst_n  <= 1'b1;
    #1000 $finish;
  end

  initial forever #5 clk = ~clk;
  
endmodule: TB


module i_mem(input logic clk, rst_n,
             input logic [31:0]  addr,
             input logic         req,
             output logic [31:0] d_out,
             output logic        grant,
             output logic        valid);

  logic [31:0] instr_mem [`IMEM_WORDS];
  
  assign grant = req;
  
  always_ff @(posedge clk) begin
    if(~rst_n) begin
      $readmemh("memory.hex", instr_mem);
      valid <= 1'b0;
      d_out <= 32'h0;
    end
    else begin
      valid <= req;
      d_out <= instr_mem[addr>>2];
    end
  end
endmodule: i_mem


module d_mem(input logic clk, rst_n,
             input logic [31:0]  addr,
             input logic         req,
             input logic         we,
             input logic [3:0]   be,
             input logic [31:0]  d_in,
             output logic [31:0] d_out,
             output logic        grant,
             output logic        valid,
             output logic        err);

  logic [31:0] data_mem [`DMEM_WORDS];

  assign err  = 1'b0;

  assign grant = req;
  
  always_ff @(posedge clk) begin
    if(~rst_n) begin
      valid <= 1'b0;
      d_out <= 32'h0;
    end
    else begin
      valid <= req;
      if(req) begin
        if(we) begin
          for(int i = 0; i < 4; i++)
            if(be[i]) data_mem[addr>>2][8*i+:8] <= d_in[8*i+:8];
        end
        else
          d_out <= data_mem[addr>>2];
      end
    end
  end
endmodule: d_mem
