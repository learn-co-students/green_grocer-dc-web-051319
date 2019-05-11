require 'pry'

def consolidate_cart(cart)
  hash_final = {}
  counts = Hash.new(0)

  cart.each do |hash|
    hash.each do |k,v|
      counts[k]+=1 
      hash_final[k] = v 
      hash_final[k][:count] = counts[k]
    end 
  end
  return hash_final
end

def apply_coupons(cart, coupons)
coupons.each do |coupon|
name = coupon[:item]
if cart[name] && cart[name][:count] >= coupon[:num]
  if cart["#{name} W/COUPON"]
    cart["#{name} W/COUPON"][:count] += 1
  else
    cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
    cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
  end
  cart[name][:count] -= coupon[:num]
end
end
cart
end 


def apply_clearance(cart)
 cart.each do |k ,v|
 if cart[k][:clearance] == true 
   cart[k][:price] = (cart[k][:price]*0.80).round(1)
 end 
end
return cart 
end 

def checkout(cart, coupons)
  checkouts = {}
  checkouts = consolidate_cart(cart)
 
  total = 0 
 
  checkouts = apply_coupons(checkouts, coupons)
  checkouts = apply_clearance(checkouts)
   checkouts.each do |item, val|
    total_item = 0 
    total_item = checkouts[item][:price]*checkouts[item][:count]
    total += total_item 
    end
   
    if total>100 
    return (total*0.90).round(2)
  else
    return total 
  end 
end
