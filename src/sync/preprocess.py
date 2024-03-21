import os 
import re 
import sys

class SynchronizationFFChainPreprocessor:

    __temp = '''module {0} #(
    parameter WIDTH = 1
) (
    input wire i_clk , i_rst,
    input wire [WIDTH - 1 : 0] i_async,
    output reg [WIDTH - 1 : 0] o_sync
);
    {1}
    
    always @(posedge i_clk or negedge i_rst) begin
        if(~i_rst)
            begin
                {2}
            end 
        else 
            begin
                {3}
            end 
    end

endmodule
'''

    __params = ['cdc-ff-size' , 'cdc-ff-name']

    def __init__(self, file = '' ,) -> None:
        self.__temp = SynchronizationFFChainPreprocessor.__temp
        
        if not os.path.exists(file):
            raise FileNotFoundError
        
        self.__path = file
        self.__imp = ''
        
        with open(self.__path , 'r') as f:
            self.__imp = f.read()

        # Find all parameters 
        pattern = re.compile(r'\/\*\s*cdc-prop\s*{([\s\S]*?)}\s*\*\/')
        
        self.__all_found_params = re.findall(pattern , self.__imp)

        self.__props = [i.split(',') for i in self.__all_found_params]
        self.__props = [dict([re.findall(r'\s*([\w-]+)\s*:\s*([\w]+)\s*' , i)[0] for i in params]) for params in self.__props]
        

        for prop in self.__props:
            self.__generate(prop)


        

    def __generate(self , props : dict):
        
        size = int(props.get('cdc-ff-size' , 2))
        name = props.get('cdc-ff-name' , f'sync_ff_{size}')


        # internal flops 
        internals = [f'meta_{i}' for i in range(size - 1)]

        definitions = [f'\treg [WIDTH - 1: 0] {flop};' for flop in internals]
        
        definitions = "\n".join(definitions)

        reset_values = ["\t\t\t\t{0} <= {WIDTH{1'b0}};".replace('{0}',flop) for flop in internals]
        reset_values = "\n".join(reset_values)
        shifters = ''

        for i in range(0, len(internals)):
            if i == 0:
                shifters += f"\t\t\t\t{internals[0]} <= i_async;\n"
                continue    
            shifters += f"\t\t\t\t{internals[i]} <= {internals[i-1]};\n"
        
        shifters += f"\t\t\t\to_sync <= {internals[len(internals) - 1]};\n"
        
        final_script = self.__temp.format(name , '\n' + definitions , "\n" + reset_values , "\n" + shifters)

        with open(f'{name}.v', 'w') as f:
            f.write(final_script)


def main():
    print(sys.argv)
    obj = SynchronizationFFChainPreprocessor(sys.argv[1])

if __name__ == "__main__":
    main()