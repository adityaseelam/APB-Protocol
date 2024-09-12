`timescale 1ns/10ps
module tb_apb();
reg PCLK;
reg PRESET;
wire[7:0] PRDATA;
wire PREADY;
reg[7:0] data_in;
reg[6:0] pwrite_addr;
reg[6:0] pread_addr;
reg write_read;
wire PSELECT1;
wire PSELECT2;
wire PENABLE;
wire PWRITE;
wire[6:0] PADDR;
wire[6:0] PWDATA;
wire[6:0] data_out;
wire[2:0] state;
wire[2:0] next_state;
wire PSLVERR;
wire error1;
wire error2;
wire error3;
/////***** EXTRA SIGNALS******//////  
wire PREADY1;
wire PREADY2;
wire[6:0] PRDATA1;
wire[6:0] PRDATA2;
  
  Master uut(.PCLK(PCLK),
             .PRESET(PRESET),
             .PRDATA(PRDATA),
             .PREADY(PREADY),
             .data_in(data_in),
             .pwrite_addr(pwrite_addr),
             .pread_addr(pread_addr),
             .write_read(write_read),
             .PSELECT1(PSELECT1),
             .PSELECT2(PSELECT2),
             .PENABLE(PENABLE),
             .PWRITE(PWRITE),
             .PADDR(PADDR),
             .PWDATA(PWDATA),
             .data_out(data_out),
             .state(state),
             .next_state(next_state),
             .PSLVERR(PSLVERR),
             .error1(error1),
             .error2(error2),
             .error3(error3)
            );
  
  Slave1 uut2( .PCLK(PCLK),
                .PRESET(PRESET),
                .PENABLE(PENABLE),
                .PWRITE(PWRITE),
                .PADDR(PADDR),
                .PWDATA(PWDATA),
                .PRDATA(PRDATA1),
                .PREADY(PREADY1),
                .PSLVERR(PSLVERR),
                .PSELECT1(PSELECT1)
              );
  
  Slave2 uut3( .PCLK(PCLK),
                .PRESET(PRESET),
                .PENABLE(PENABLE),
                .PWRITE(PWRITE),
                .PADDR(PADDR),
                .PWDATA(PWDATA),
                .PRDATA(PRDATA2),
                .PREADY(PREADY2),
                .PSLVERR(PSLVERR),
                .PSELECT2(PSELECT2)
              );
  assign PREADY = PADDR[6] ? PREADY1 : PREADY2 ;
  assign PRDATA = PADDR[6] ? PRDATA1 : PRDATA2 ;
  
always #5 PCLK=~PCLK;
  integer i;

  initial begin
    PCLK=0;
    PRESET=0;
    
    #15;
    PRESET=1;
    write_read=1;
    #10;
    ///**********WRITING SLAVE 1*******************
    for(i=0;i<6;i=i+1) begin
      pwrite_addr={1'b1,i[5:0]};
      #10;
      data_in=i;
      //#20; correct
      #10;
    end
    PRESET=0;
    #10
    PRESET=1;
    write_read=0;
    #10;
    ///**********READING SLAVE 1*****************
    for(i=0;i<6;i=i+1) begin
    pread_addr={1'b1,i[5:0]};
    #20;
  end
  PRESET=0;
  #10;
  PRESET=1;
  write_read=1;
  // #10;
    ///**********WRITING SLAVE 2*******************
    for(i=0;i<6;i=i+1) begin
      pwrite_addr={1'b0,i[5:0]};
      #10;
      data_in=i*i;
      //#20; correct
      #10;
    end
    PRESET=0;
    #10;
     PRESET=1;
    write_read=0;
    //#10;
    ///**********READING SLAVE 2*****************
    for(i=0;i<6;i=i+1) begin
    pread_addr={1'b0,i[5:0]};
    #20;
  end
  PRESET=0;

  end

endmodule
    
    
  
            
