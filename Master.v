 module Master(input PCLK,
               input PRESET,
               input[7:0] PRDATA,
               input PREADY,
               input[7:0] data_in,
               input[6:0] pwrite_addr,
               input[6:0] pread_addr,
               input write_read,
               output reg PSELECT1,
               output reg PSELECT2,
               output reg PENABLE,
               output reg PWRITE,
               output reg[6:0] PADDR,
               output reg[6:0] PWDATA,
               output reg[6:0] data_out,
               output reg[2:0] state, 
               output reg[2:0] next_state,
               output reg PSLVERR,
               output reg error1,
               output reg error2,
               output reg error3
               

 );

parameter IDLE= 3'b000;
parameter SETUP=3'b001;
parameter ENABLE=3'b111;

//****************SEQUENTIAL STATE*******************
always@(posedge PCLK) begin
    if(!PRESET) begin
        PENABLE=0;
        state<=IDLE;
    end else begin
    state<=next_state;
    end
end

//****************COMBINATIONAL STATE******************

always@(*) begin
    next_state=state;
    case(state) 

IDLE: begin
    PENABLE=0;
    if(write_read==1) begin
        PWRITE=1;
        next_state=SETUP;
    end else if(write_read==0)begin
        PWRITE=0;
        next_state=SETUP;
    end else begin
        next_state=IDLE;
    end
end

SETUP: begin
    PENABLE=0;
    if(!PSLVERR) begin
    if(write_read) begin
        PADDR=pwrite_addr;
    end else if(!write_read) begin
        PADDR=pread_addr;
    end
    PSELECT1= PADDR[6] ? 1'b1 : 1'b0;
    PSELECT2= PADDR[6] ? 1'b0 : 1'b1;
    if(PSELECT1 || PSELECT2) begin
        next_state=ENABLE;
    end else begin
        next_state= SETUP;
    end 
    end else  begin
        next_state=IDLE;
    end
end

ENABLE: begin
    PENABLE=1;
    if(!PSLVERR) begin
    if(PREADY) begin
    if(PWRITE) begin
    PWDATA=data_in;
    next_state=SETUP;    
    end else if(!PWRITE) begin
        data_out=PRDATA;
        next_state=SETUP;
    end 
    end else begin
        next_state=ENABLE;
    end
    end else begin
        next_state=IDLE;
    end
end

default: next_state=IDLE;
    endcase
end
    
always@(*) begin
    if(!PRESET) begin
        error1=0;
        error2=0;
        error3=0;
    end else begin
if(state==IDLE && next_state==ENABLE) 
    error1=1;
 else error1=0;
if((PWRITE) && (state==SETUP || state== ENABLE) && (pwrite_addr==7'dx) ) 
    error2=1;
 else error2=0;

if((!PWRITE) && (state==SETUP || state== ENABLE) && (pread_addr==7'dx) ) 
error3=1;
else error3=0;
end
 PSLVERR=(error1 || error2 || error3);
end

endmodule



    





 
