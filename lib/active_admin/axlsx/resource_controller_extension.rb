module ActiveAdmin
  module Axlsx
    module ResourceControllerExtension
      def self.included(base)
        base.send :respond_to, :xlsx
      end

      # patching the index method to allow the xlsx format.
      def index(*args, &block)
        super(*args) do |format|
           format.xlsx do
            xlsx = active_admin_config.xlsx_builder.serialize(collection, view_context)
            send_data xlsx, :filename => "#{xlsx_filename}", :type => Mime::Type.lookup_by_extension(:xlsx)
          end
        end
      end

      # patching per_page to use the CSV record max for pagination when the format is xlsx
      def per_page
        if request.format == Mime::Type.lookup_by_extension(:xlsx)
          1_000_000
        else
          super()
        end
      end

      # Returns a filename for the xlsx file using the collection_name
      # and current date such as 'my-articles-2011-06-24.xlsx'.
      def xlsx_filename
        "#{resource_collection_name.to_s.gsub('_', '-')}-#{Time.now.strftime("%Y-%m-%d")}.xlsx"
      end
    end
  end
end
