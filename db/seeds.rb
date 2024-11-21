require 'csv'

user_0 = User.create!(first_name: 'Manager', last_name: ' Store', password: '123123123@q', email: 'manager@store.com')


csv_file_path = Rails.root.join('db', 'seed_files', 'categories.csv')

CSV.foreach(csv_file_path, headers: true) do |row|
  category = Category.find_by(id: row['id'])
  if category.present?
    next
  end

  Category.create(
    id: row['id'],
    category_name: row['categoryName'],
    created_at: row['createdAt'],
    updated_at: row['updatedAt']
  )
end

csv_file_path = Rails.root.join('db', 'seed_files', 'products.csv')

CSV.foreach(csv_file_path, headers: true) do |row|
  product = Product.find_by(id: row['id'])
  if product.present?
    next
  end

  product = Product.create(
    id: row['id'],
    category_id: row['categoryId'],
    product_name: row['productName'],
    stock_quantity: row['stockQuantity'],
    status: row['status'],
    created_at: row['createdAt'],
    updated_at: row['updatedAt']
  )


end

csv_file_path = Rails.root.join('db', 'seed_files', 'batches.csv')

CSV.foreach(csv_file_path, headers: true) do |row|
  batch = Batch.find_by(id: row['id'])
  if batch.present?
    next
  end

  Batch.create(
    id: row['id'],
    product_id: row['productId'],
    batch_number: row['batchNumber'],
    quantity: row['quantity'],
    price: row['price'],
    expiration_date: row['expirationDate'],
    manufacture_date: row['manufactureDate'],
    created_at: row['createdAt'],
    updated_at: row['updatedAt']
  )
end

CSV.foreach(Rails.root.join('db', 'seed_files', 'batches.csv'), headers: true) do |row|
  Customer.create!({
    first_name: row['first_name'],
    last_name: row['last_name'],
    status: row['status'].to_i,
    birth: row['birth'],
    phone: row['phone'],
    password: '123123123@q'
  })
end