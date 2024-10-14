# frozen_string_literal: true

module V1
  module Users
    class Categories < PublicBase
      resources :categories do
        desc 'Get all categories',
             summary: 'Get all categories'
        params do
          optional :search, type: String, desc: 'Search category by name'
          optional :page, type: Integer, desc: 'Page number'
          optional :per_page, type: Integer, desc: 'Per page number'
        end
        get do
          categories = if params[:search].present?
                         Category.where('category_name LIKE ?', "%#{params[:search]}%")
                       else
                         Category.all
                       end
          paginated_response(categories)
        end

        desc 'Create a new category',
             summary: 'Create a new category'
        params do
          requires :category_name, type: String, desc: 'Name of the category'
        end
        post do
          category = Category.new(category_name: params[:category_name])
          if category.save
            { message: 'Category created successfully', category: category }
          else
            error!(category.errors.full_messages, 422)
          end
        end

        desc 'Get a category by ID',
             summary: 'Get a category by ID'
        params do
          requires :id, type: Integer, desc: 'ID of the category'
        end
        get ':id' do
          category = Category.find(params[:id])
          present category
        rescue ActiveRecord::RecordNotFound
          error!('Category not found', 404)
        end

        desc 'Update a category',
             summary: 'Update a category'
        params do
          requires :id, type: Integer, desc: 'ID of the category'
          requires :category_name, type: String, desc: 'New name of the category'
        end
        put ':id' do
          category = Category.find(params[:id])
          if category.update(category_name: params[:category_name])
            { message: 'Category updated successfully', category: category }
          else
            error!(category.errors.full_messages, 422)
          end
        rescue ActiveRecord::RecordNotFound
          error!('Category not found', 404)
        end

        desc 'Delete a category',
             summary: 'Delete a category'
        params do
          requires :id, type: Integer, desc: 'ID of the category'
        end
        delete ':id' do
          category = Category.find(params[:id])
          category.destroy
          { message: 'Category deleted successfully' }
        rescue ActiveRecord::RecordNotFound
          error!('Category not found', 404)
        end
      end
    end
  end
end
