module Slave2(input PCLK,input PRESET,input PENABLE,input PWRITE,input[6:0] PADDR,input[7:0] PWDATA,output reg[7:0] PRDATA,output reg PREADY,output PSLVERR,input PSELECT2);
  
  reg[7:0] memory2[0:127];
  
  always@(*)begin
    
    if(!PRESET) begin
      PREADY=0;
    end else 
      if(PSELECT2 && !PENABLE && PWRITE) begin
        PREADY=0;
        //memory1[PADDR]<=PWDATA;
      end else 
       if(PSELECT2 && PENABLE && PWRITE) begin
         PREADY=1;
         memory2[PADDR]=PWDATA;
       end else 
         if(PSELECT2 && PENABLE && !PWRITE) begin  
           PREADY=1;
           PRDATA=memory2[PADDR];
         end else 
         if(PSELECT2 && !PENABLE && !PWRITE) begin  
           PREADY=0;
         end
  end
    endmodule
        
    
  
