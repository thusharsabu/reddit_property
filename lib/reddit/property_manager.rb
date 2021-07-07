
require 'csv'  

module Reddit
  class PropertyManager
    class << self

      def populate_properties
        filename = File.join(Dir.pwd, 'config', 'redfin_2021-07-06-10-32-21.csv')

        csv = CSV.open(filename, headers: :first_row).map(&:to_h)

        index_value = 1

        csv.each do |data|
          data['UPVOTE'] = 0
          data['DOWNVOTE'] = 0
          data['CREATED_AT'] = Time.now
          data['ID'] = index_value

          index_value += 1
        end

        write_data(data: csv)
      end

      def write_data(data:)
        File.open(File.join(Dir.pwd, 'data', 'data.json'), 'w') do |f|
          f.write(JSON.pretty_generate(data))
        end
      end
    end
  end
end