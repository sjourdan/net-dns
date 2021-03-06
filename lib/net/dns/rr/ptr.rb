module Net # :nodoc:
  module DNS
    class RR

      #
      # = Pointer Record (PTR)
      #
      # Class for DNS Pointer (PTR) resource records.
      #
      # Pointer records are the opposite of A and AAAA RRs 
      # and are used in Reverse Map zone files to map
      # an IP address (IPv4 or IPv6) to a host name.
      #
      class PTR < RR

        # Getter for PTR resource
        def ptr
          @ptrdname.to_s
        end
        alias_method :ptrdname, :ptr

        private

        def check_ptr(str)
          IPAddr.new str
        rescue
          raise ArgumentError, "PTR section not valid"
        end

        def build_pack
          @ptrdname_pack = pack_name(@ptrdname)
          @rdlength = @ptrdname_pack.size
        end

        def get_data
          @ptrdname_pack
        end

        def get_inspect
          "#@ptrdname"
        end

        def subclass_new_from_hash(args)
          if args.has_key? :ptrdname or args.has_key? :ptr
            @ptrdname = args[0][:ptrdname]
          else
            raise ArgumentError, ":ptrdname or :ptr field is mandatory but missing"
          end
        end

        def subclass_new_from_string(str)
          @ptrdname = check_ptr(str)
        end

        def subclass_new_from_binary(data,offset)
          @ptrdname,offset = dn_expand(data,offset)
          return offset
        end

        private

          def set_type
            @type = Net::DNS::RR::Types.new("PTR")
          end
        
      end

    end
  end
end
