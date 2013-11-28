module Cequel
  module Record
    module BulkWrites
      def update_all(attributes)
        each_data_set { |data_set| data_set.update(attributes) }
      end

      def delete_all
        each_data_set { |data_set| data_set.delete }
      end

      private

      def each_data_set
        key_attributes_for_each_row.each_slice(100) do |batch|
          connection.batch(:unlogged => true) do
            batch.each { |key_attributes| yield keyspace.where(key_attributes) }
          end
        end
      end
    end
  end
end
