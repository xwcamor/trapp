#json.array! @transformers, partial: "customer_management/user_customer_transformers/partials/transformer", as: :transformer

json.array!  @transformers  do |transformer|
  json.id transformer.id
  json.num_serie transformer.num_serie
  json.customer_id transformer.customer_substation.customer_id

end