require "pry"

def consolidate_cart(cart)
  # code here
  hCart = {}
  unqCart = cart.uniq
  unqCart.each{|uitem| uitem[uitem.keys.join]=uitem[uitem.keys.join].merge({:count => cart.collect{|item| item==uitem ? item : nil}.compact.length.to_i})} #Getting the count
  unqCart.each{|toHash| hCart=hCart.merge(toHash)}
  hCart
end

def apply_coupons(cart, coupons)
  # code here
coupons.each{|coupon|
  if cart.include?(coupon[:item])
    if cart[coupon[:item]][:count] >= coupon[:num]
      cart[coupon[:item]+" W/COUPON"]={ :price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => cart[coupon[:item]][:count] / coupon[:num] }
      if cart[coupon[:item]][:count] % coupon[:num] == 0 ? cart[coupon[:item]][:count]=0 : cart[coupon[:item]][:count]=cart[coupon[:item]][:count] % coupon[:num]
    end
  end
end
}
cart
end

def apply_clearance(cart)
  # code here
  cart.each{|k,v| 
  cart[k][:clearance] ? cart[k][:price]=(cart[k][:price] * 0.8).truncate(2) : cart[k][:price]=cart[k][:price]
  }
end

def checkout(cart, coupons)
  # code here
  total=0.0
  cart=consolidate_cart(cart)
  apply_coupons(cart,coupons)
  apply_clearance(cart)
  cart.each{|k,v| cart[k][:count]!=0 ? total+=(cart[k][:price]*cart[k][:count]) : total}
  total>100.00 ? total=total*0.9 : total
  total
end
