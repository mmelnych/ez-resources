module Ez
  module Resources
    class CollectionCell < ApplicationCell
      include Pagy::Frontend

      delegate :resources_name, :collection_columns, :paginator, to: :model

      def collection
        @collection ||= model.data
      end

      def collection_size
        @collection_size ||= collection.size
      end

      def header_text
        "#{resources_name} (#{collection_size})"
      end

      def record_column_value(record, column)
        if column.type == :association
          column.getter.call(record)
        else
          record.public_send(column.name)
        end
      end

      def edit_link(record)
        return unless model.actions.include?(:edit)
        return unless can_edit?(record)

        link_to t("actions.edit"), model.path_for(action: :edit, id: record.id)
      end

      def remove_link(record)
      end

      def pagination
        if Ez::Resources.config.pagination_method
          instance_exec paginator, &Ez::Resources.config.pagination_method
        else
          pagy_nav(paginator)
        end
      end

      private

      def can_edit?(record)
        Manager::Hooks.can?(:can_edit?, model.hooks, record)
      end
    end
  end
end
