class Ldapsearch
  class << self
    def group_hash(file = 'temp.txt')
      group, hash, cn = false, {}, ""
      File.open("data/#{file}").each do |line|
        group = true if line.match(/ou=group/)
        group = false if line == "\n"
        if group
          if data = line.match(/cn: (\w+)/)
            cn = data[1]
          end
          if data = line.match(/gidNumber: (\d+)/)
            hash[data[1]] = cn
          end
        end
      end
      return hash
    end

    def read(hash)
      people, gid = false, ""
      File.open('data/temp.txt').each do |line|
        people = true if people_match(line) 
        people = false if line == "\n"
        if people
          if data = line.match(/gidNumber: (\d+)/)
            gid = "#{hash[data[1]]}|#{data[1]}"
          end
          if data = line.match(/homeDirectory: (.*)/)
            Dailystat.create(path:data[1].chop,gid_string:gid.split('|')[0],gid_num:gid.split('|')[1])
          end
        end
      end
    end #read

    def people_match(line); line.match(/ou=\"?people\"?/i) end
  end
end
