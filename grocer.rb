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
  h_coup_invert = {}
  hash_cart = {} 
  hash_coup = {}
  hash_cart_coup = {}
  counts = Hash.new(0)
   
 hash_cart = hash_cart.merge(cart)
 unless coupons.size == 0 || coupons.nil?
 coupons.each do |h_coup|
   h_coup_invert = h_coup.invert
   h_coup_invert.each do |k,v|
    
    if (cart.keys.include?(k)  && hash_cart[k][:count] >= h_coup[:num])
      
      
      hash_cart[k][:count]-=h_coup[:num]
      
      hash_coup = hash_coup.merge(hash_cart[k])
      hash_cart_coup[k] = hash_cart_coup.merge(hash_cart[k]) 
      hash_cart_coup["#{k} W/COUPON"] = hash_coup
      hash_cart_coup["#{k} W/COUPON"] = hash_cart_coup["#{k} W/COUPON"].replace({:price => h_coup[:cost], :clearance => hash_cart[k][:clearance], :count => counts[k]+=1})
      end

end
end 
return hash_cart_coup
else 
  return cart 
end 
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
