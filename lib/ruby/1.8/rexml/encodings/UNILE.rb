module REXML
  module Encoding
    class UNILEEncoder
      def encode content
        array_utf8 = content.unpack("U*")
        array_enc = []
        array_utf8.each do |num|
          if ((num>>16) > 0)
            array_enc << ??
            array_enc << 0
          else
            array_enc << (num & 0xFF)
            array_enc << (num >> 8)
          end
        end
        array_enc.pack('C*')
      end
      
      def decode(str)
        array_enc=str.unpack('C*')
        array_utf8 = []
        0.step(array_enc.size-1, 2){|i| 
          array_utf8 << (array_enc.at(i) + array_enc.at(i+1)*0x100)
        }
        array_utf8.pack('U*')
      end
    end

    unile = UNILEEncoder.new
    register(UNILE) do |obj|
      obj.encoder = unile
    end
  end
end
