class TEAUTIL  
  class << self  
    private
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
    public
      def get_date_array(str)
        date_array = []
        reg_date = /^[\d]{8}T[\d]{6}P[\d]/
        if reg_date.match(str)
          date_array = reg_date.scan(reg_date)
        end

        return date_array
      end
  end
end