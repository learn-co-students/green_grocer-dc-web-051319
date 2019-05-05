def consolidate_cart(cart)
  cart_hash = {}
  
  cart.each do |item|
    item.each do |name, values|
      if cart_hash.has_key?(name)
        cart_hash[name][:count] += 1  
      else  
        cart_hash[name] = values
        cart_hash[name][:count] = 1
      end
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)
  cart_after_coupons = {}
  
  cart.each do |key, value|
    cart_after_coupons[key] = value
  end
  
  coupons.each do |keys, value|
    if cart.has_key?(keys[:item])
      if cart[keys[:item]][:count] >= keys[:num]
        if cart_after_coupons.has_key?("#{keys[:item]} W/COUPON")
          cart_after_coupons["#{keys[:item]} W/COUPON"][:count] += 1
          cart_after_coupons[keys[:item]][:count] -= keys[:num]
        else
        cart_after_coupons["#{keys[:item]} W/COUPON"] = {
          :price => keys[:cost],
          :clearance => cart_after_coupons[keys[:item]][:clearance],
          :count => 1   
        }
        cart_after_coupons[keys[:item]][:count] -= keys[:num]
      end
      end
    end
  end
  cart_after_coupons
end

def apply_clearance(cart)
  cart.each do |item, value|
    if cart[item][:clearance] == true
      cart[item][:price] -= (cart[item][:price] * 0.20)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0.0
  hash = consolidate_cart(cart)
  hash = apply_coupons(hash, coupons)
  hash = apply_clearance(hash)
  
  hash.each do |item, value|
    total += (hash[item][:price] * hash[item][:count])
  end
  
  if total > 100
    total -= (total * 0.10)
  else
    total
  end
  
end


