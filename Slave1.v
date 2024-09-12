module Slave1(input PCLK,input PRESET,input PENABLE,input PWRITE,input[6:0] PADDR,input[7:0] PWDATA,output reg[7:0] PRDATA,output reg PREADY,output PSLVERR,input PSELECT1);
  
  reg[7:0] memory1[0:127];
  
  always@(*)begin
    
    if(!PRESET) begin
      PREADY=0;
    end else 
      if(PSELECT1 && !PENABLE && PWRITE) begin
        PREADY=0;
        //memory1[PADDR]<=PWDATA;
      end else 
       if(PSELECT1 && PENABLE && PWRITE) begin
         PREADY=1;
         memory1[PADDR]=PWDATA;
       end else 
         if(PSELECT1 && PENABLE && !PWRITE) begin  
           PREADY=1;
           PRDATA=memory1[PADDR];
         end else 
         if(PSELECT1 && !PENABLE && !PWRITE) begin  
           PREADY=0;
         end
  end
    endmodule
        
    
  
