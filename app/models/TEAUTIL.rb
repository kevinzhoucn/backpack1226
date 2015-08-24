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
          date_array << str.split('P')[1]
        end

        return date_array
      end

      def get_date_seconds(str)
        date_array = get_date_array(str)
        date_year = date_array[0] + date_array[1]
        date = Time.local(date_year, date_array[2], date_array[3], date_array[4], date_array[5], date_array[6])
        # date = Time.gm(date_year.to_i, date_array[2].to_i, date_array[3].to_i, date_array[4].to_i, date_array[5].to_i, date_array[6].to_i)
        # date = Time.new(2015, 10, 5, 10, 12, 20, "+08:00")
        # date = Time.at(date, date_array[7])
        # date = Time.gm(date_array[0] + date_array[1], date_array[2], date_array[3], date_array[4], date_array[5], date_array[6], date_array[7])
        return ( date.to_i + 8 * 3600 ) * 1000
      end
  end
end