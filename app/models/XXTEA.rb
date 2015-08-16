############################################################  
#                                                          #  
# The implementation of PHPRPC Protocol 3.0                #  
#                                                          #  
# xxtea.rb                                                 #  
#                                                          #  
# Release 3.0.0                                            #  
# Copyright (c) 2005-2008 by Team-PHPRPC                   #  
#                                                          #  
# WebSite:  http://www.phprpc.org/                         #  
#           http://www.phprpc.net/                         #  
#           http://www.phprpc.com/                         #  
#           http://sourceforge.net/projects/php-rpc/       #  
#                                                          #  
# Authors:  Ma Bingyao <andot@ujn.edu.cn>                  #  
#                                                          #  
# This file may be distributed and/or modified under the   #  
# terms of the GNU Lesser General Public License (LGPL)    #  
# version 3.0 as published by the Free Software Foundation #  
# and appearing in the included file LICENSE.              #  
#                                                          #  
############################################################  
#  
# XXTEA encryption arithmetic library.  
#  
# Copyright (C) 2005-2008 Ma Bingyao <andot@ujn.edu.cn>  
# Version: 1.0  
# LastModified: Aug 20, 2008  
# This library is free.  You can redistribute it and/or modify it.  
  
class XXTEA  
  class << self  
  private  
  
    Delta = 0x9E3779B9  
  
    def long2str(v, w)  
      n = (v.size - 1) << 2  
      if w then  
        m = v.last  
        if (m < n - 3) or (m > n) then return '' end  
        n = m  
      end  
      s = v.pack("N*")  
      return w ? s[0, n] : s  
    end  
  
    def str2long(s, w)  
      n = s.length;  
      v = s.ljust((4 - (n & 3) & 3) + n, "\0").unpack("N*")
      if w then v[v.size] = n end  
      return v  
    end  
  
    def mx(z, y, sum, k, p, e)  
      return ((z >> 5 ^ ((y << 2) & 0xffffffff)) + (y >> 3 ^ ((z << 4) & 0xffffffff)) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z)) & 0xffffffff  
    end  
  
  public  
    def encrypt(str, key)  
      if str.empty? then return str end  
      v = str2long(str, false)#.map {|item| item.to_s(16) } 
      k = str2long(key.ljust(16, "\0"), false)#.map {|item| item.to_s(16) }
      # v = [0x31323334, 0x35363738, 0x39000000]
      # k = [0x31323334, 0x35363738, 0x39306162, 0x63646566]
      n = v.size - 1  
      z = v[n]  
      y = v[0]  
      sum = 0  
      (6 + 52 / (n + 1)).downto(1) { |q|  
        sum = (sum + Delta) & 0xffffffff  
        e = sum >> 2 & 3  
        for p in (0...n)  
          y = v[p + 1]  
          z = v[p] = (v[p] + mx(z, y, sum, k, p, e)) & 0xffffffff  
        end  
        y = v[0]  
        z = v[n] = (v[n] + mx(z, y, sum, k, n, e)) & 0xffffffff  
      } 
      long2str(v, false)  
    end  
  
    def decrypt(str, key)  
      if str.empty? then return str end  
      v = str2long(str, false)  
      k = str2long(key.ljust(16, "\0"), false)  
      n = v.size - 1  
      z = v[n]  
      y = v[0]  
      q = 6 + 52 / (n + 1)  
      sum = (q * Delta) & 0xffffffff  
      while (sum != 0)  
        e = sum >> 2 & 3  
        n.downto(1) { |p|  
          z = v[p - 1]  
          y = v[p] = (v[p] - mx(z, y, sum, k, p, e)) & 0xffffffff  
        }  
        z = v[n]  
        y = v[0] = (v[0] - mx(z, y, sum, k, 0, e)) & 0xffffffff  
        sum = (sum - Delta) & 0xffffffff  
      end  
      long2str(v, false)  
    end  

    def encode_test(str, key)
      # str_long = str2long("123456789", false).map {|item| item.to_s(16) }
      # return long_str = long2str(str_long, false)

      # return str2long("123456789", true)#.map {|item| item.to_s(16) }

      # return encrypt("123456789", "1234567890abcdef").unpack('N*').map { |item| item.to_s(16) }
      
      # return encrypt("1-0-20150512T123456P123_64-2046-20150512T101123P456", "1234567890abcdef")#.unpack('N*').map { |item| item.to_s(16) }
      str = encrypt("123456789", "1234567890abcdef")#.unpack('V*').map { |item| item.to_s(16) }
      return decrypt(str, "1234567890abcdef")
    end

    def get_encrypt_str(str, key)
      if str.length < 8
        str = str.ljust(8, "\0")
      end
      encrypt_str = encrypt(str, key)
      return encrypt_str.unpack('N*').map { |m| format("%08x", m)}.join
    end

    def get_decrypt_str(raw_str, raw_key)
      decrypt_str = ""
      ret_str = raw_str.scan(/.{8}/).map { |m| m.to_i(16) }.pack('N*')
      decrypt_str = XXTEA.decrypt(ret_str, raw_key)
      decrypt_str.strip
    end
  end  
end  