require 'pry'

def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |items_array|
    items_array.each do |item, attribute_hash|
      cart_hash[item] = attribute_hash
      cart_hash[item][:count] ? cart_hash[item][:count] += 1 :
      cart_hash[item][:count] = 1
    end
  end
  return cart_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    if cart[item] 
      if cart[item][:count] >= coupon[:num] && !cart.has_key?("#{item} W/COUPON")
        cart["#{item} W/COUPON"] = {price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
        cart[item][:count] -= coupon[:num]
      elsif cart[ item][:count] >= coupon[:num] && cart.has_key?("#{item} W/COUPON")
        cart["#{item} W/COUPON"][:count] += coupon[:num]
        cart[item][:count] -= coupon[:num]
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item_name, stats|
    stats[:price] -= stats[:price] * 0.20 if stats[:clearance]
  end
  return cart
end

def checkout(array, coupon)
  hash_cart = consolidate_cart(array)
  apply_coupons = apply_coupons(hash_cart, coupon)
  applied_discount = apply_clearance(apply_coupons)
  total = applied_discount.reduce(0) { |acc, (k, v)| acc += v[:price] + v[:count]
  }
  if total > 100
    return total * .90
  else
    return total
  end
end