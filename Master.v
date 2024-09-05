 module Master(input PCLK,input PRESET,output reg PSELECT1,output reg PSELECT2,output reg PWRITE, output reg PENABLE,output reg[6:0] PADDR,output reg[7:0] PWDATA,input[7:0] PRDATA, input PSLVERR, input PREADY,output reg[2:0] state,input write_read,input[6:0] write_addr,input[7:0] write_data,output reg[7:0] read_data,input[6:0] read_addr );
  
  
  parameter IDLE=2'b00;
  parameter SETUP=2'b01;
  parameter ENABLE=2'b11;
 // PWRITE=write_read;
 
  
  always@(posedge PCLK)begin
    if(PRESET) begin
      state<=IDLE;
      end else begin
     case(state) 
IDLE: begin
   PENABLE<=0;
  if(write_read) begin
    PWRITE<=1;
  state<=SETUP;
end else if(!write_read) begin
    PWRITE<=0;
  state<=SETUP;
end else begin
  state<=IDLE;
end
end       
       
      
SETUP: begin
  PENABLE<=0;
  if(PSELECT1 || PSELECT2) begin
    state<=ENABLE;
  end else begin
    state<=IDLE;
  end
end
 
ENABLE: begin
      PENABLE<=1;
  if(PREADY) begin
      
      if(PWRITE) begin
    PADDR<=write_addr;
    PWDATA<=write_data;
        state<=SETUP;
   end else if(!PWRITE)begin
     PADDR<=read_addr;
      read_data<=PRDATA;
      state<=SETUP;
    end 
  end else begin
    state<=ENABLE;
  end
end
 
 default: state<=IDLE;
     endcase
      end 
      end
    endmodule