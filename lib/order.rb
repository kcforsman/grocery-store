require 'csv'
require 'awesome_print'

module Grocery
  class Order
    attr_reader :id, :products

    @@all_orders = []

# Initialize Method that also calls method
# to split csv product list string
    def initialize(id, products)
      @id = id
      @products = useful_data(products)
    end
# Method for splitting product strings into hashes
    def useful_data(data)
      if data.class == String
        grouped_products = data.split(";")
        product_pairs = {}
        grouped_products.each do |grouped_item|
          separated_item = grouped_item.split(":")
          product_pairs[separated_item[0]] = separated_item[1].to_f.round(2)
        end
        product_pairs
      elsif data.class == Hash
        data
      end
    end
# Sum of product cost method
    def total
      # TODO: implement total
      subtotal = 0
      @products.each do |product, price|
        subtotal += price
      end
      (subtotal + (subtotal * 0.075)).round(2)
    end
# method to add additional products to an existing order
    def add_product(product_name, product_price)
      # TODO: implement add_product
      if @products[product_name]
        false
      else
        @products[product_name] = product_price
        true
      end
    end
# option enhancement: removes product from an existing order
    def remove_product(product_name)
      if @products[product_name]
        @products.delete(product_name)
        true
      else
        false
      end
    end
# returns array of all orders in the CSV
    def self.all
      @@all_orders = []
      CSV.read("support/orders.csv").each do |order|
        an_order = self.new(order[0].to_i, order[1])
        @@all_orders << an_order
      end
      @@all_orders
    end
# returns instance of order that matches the given order id
    def self.find(id)
      self.all.each do |order|
        if id == order.id
          return order
        end
      end
      raise ArgumentError
    end

  end
end

# experimenting with csv data and formatting
# to understand the way the file works
# def making_usable_orders(grouped_orders)
#   separated_orders = []
#   grouped_orders.each do |grouped_order|
#     grouped_items = grouped_order[1].split(";")
#     separated_items = {}
#     grouped_items.each do |grouped_item|
#       separated_item = grouped_item.split(":")
#       separated_items[separated_item[0]] = separated_item[1]
#     end
#     order = Grocery::Order.new(grouped_order[0], separated_items)
#     separated_orders << order
#   end
#   separated_orders
# end
# ###
# organized_orders = making_usable_orders(orders)
# ####
# ap organized_orders

# random_orders = [[1, "Slivered Almonds:22.88;Wholewheat flour:1.93;Grape Seed Oil:74.9"],
# [2, "Albacore Tuna:36.92;Capers:97.99;Sultanas:2.82;Koshihikari rice:7.55"],
# [3, "Lentils:7.17"]]
#
# testing_class_initialize = []
# random_orders.each do |order|
#   new_order_instance = Grocery::Order.new(order[0], order[1])
#   testing_class_initialize << new_order_instance
# end
#
# ap testing_class_initialize
