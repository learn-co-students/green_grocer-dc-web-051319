require 'pry'

def consolidate_cart(cart)
    cart.each_with_object({}) do |item, org_cart|
        item.each do |name, values|
            org_cart[name] ||= values
            org_cart[name][:count] ||= 0
            if org_cart[name][:count]
                org_cart[name][:count] += 1
            end
        end
    end
end

def apply_coupons(cart, coupons)
    cart_with_coupons = {}
    coupons.each do |coupon|
        cart.each do |name, values|
            cart_with_coupons[name] = values
            if name == coupon[:item] && values[:count] >= coupon[:num]  
                bundle = values.clone
                bundle[:count] /= coupon[:num]
                bundle[:price] = coupon[:cost]
                values[:count] %= coupon[:num]
                cart_with_coupons[name + " W/COUPON"] = bundle
            end
        end
    end
    cart_with_coupons == {} ? cart : cart_with_coupons
end

def apply_clearance(cart)
    cart.each do |name, values|
        if values[:clearance] 
             values[:price]= (0.8 * values[:price]).round(2)
        end
    end
    cart
end

def checkout(cart, coupons)
    final_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
    subtotal = 0
    final_cart.each{ |item, values| subtotal += (values[:price] * values[:count])}
    subtotal > 100 ? (subtotal * 0.9).round(2) : subtotal
end
