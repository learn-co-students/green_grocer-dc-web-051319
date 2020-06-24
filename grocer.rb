require 'pry'

def consolidate_cart(cart)
  cart.each_with_object({}) do |item, result|
    item.each do |type, attributes|
      if result[type]
        attributes[:count] += 1
      else
        attributes[:count] = 1
        result[type] = attributes
      end
    end
  end
  #binding.pry
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count]  >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
       #binding.pry
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance] == true
      info[:price] = ((info[:price])*(0.80)).round(1)
      #binding.pry
    else
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  consoldiated_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(consoldiated_cart, coupons)
  cart_w_coupons_clearance = apply_clearance(cart_with_coupons)
  
  cart_w_coupons_clearance.each do |item, details|
    total += details[:price] * details[:count]
  end
    if total > 100
      grand_total = total * (0.9)
      grand_total
    else
      total
    end
end
