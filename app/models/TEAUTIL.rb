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
          date_array = str.split('P')[0].scan(/\d{2}/)
        end

        return date_array
      end

      def get_date_string(str)
        date_array = get_date_array(str)
        date = Time.local(date_array[0] + date_array[1], date_array[2], date_array[3], date_array[4], date_array[5], date_array[6])
        return date.to_i
      end
  end
end