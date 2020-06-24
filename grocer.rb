def consolidate_cart(cart)
  nu_hash = {}
  cart.each do |item|
    name = item.keys[0]
    price = item[name][:price]
    clearance = item[name][:clearance]
    if nu_hash[name]
      nu_hash[name][:count] += 1
    else
      nu_hash[name] = {:price => price, :clearance => clearance, :count => 1}
    end
  end
  nu_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]
    if cart[item_name]
      count = cart[item_name][:count]
      num = coupon[:num]
      clear = cart[item_name][:clearance]
      if count >= num
        cart[item_name][:count] = count - num
        if cart[item_name + " W/COUPON"]
          cart[item_name + " W/COUPON"][:count] += 1
        else
          cart[item_name + " W/COUPON"] = {:price => coupon[:cost], :clearance => clear, :count => 1}
        end
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item_name, item|
    if item[:clearance]
      item[:price] = (item[:price] * 0.8).round(2)
    end
  end
  cart # code here
end

def total_cart(cart)
  total = 0
  cart.each do |item_name, item|
    total += (item[:price] * item[:count])
  end
  if total > 100
    total = (total * 0.9).round(2)
  end
  return total
end


def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupons_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(coupons_cart)
  total = total_cart(clearance_cart)
return total   # code here
end
