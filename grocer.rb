require 'pry'

def consolidate_cart(cart)
  item_arr = []
  return_hash = {}
  cart.each {|value|
    value.each{|item, info|
      item_arr << item
      info[:count] = item_arr.count(item)
      return_hash[item] = info
    }
  }
  return_hash
end

def apply_coupons(cart, coupons)
  return_hash = {}
  cart.each {|item, attributes|
    return_hash[item] = attributes
    coupons.each{|coupon|
      if (coupon[:item] == item) && (coupon[:num] <= return_hash[item][:count])
        return_hash[item][:count] = attributes[:count] - coupon[:num]
        return_hash["#{item} W/COUPON"] = {price: coupon[:cost], clearance: attributes[:clearance], count: coupons.count(coupon)}
      elsif (coupon[:item] == item) && (coupon[:num] > return_hash[item][:count])
        counter = 1
        return_hash["#{item} W/COUPON"] = {price: coupon[:cost], clearance: attributes[:clearance], count: (coupons.count(coupon) - counter)}
        counter += 1
      end
    }
  }
  return_hash
end

def apply_clearance(cart)
  cart.each{|item, attribute|
    if attribute[:clearance] == true
      attribute[:price] = attribute[:price] - (attribute[:price] * 0.20)
    end
  }
  cart
end

def checkout(cart, coupons)
  checkout_total = 0
  #binding.pry
  cart = consolidate_cart(cart)
  #binding.pry
  cart = apply_coupons(cart, coupons)
  #binding.pry
  cart = apply_clearance(cart)
  #binding.pry
  cart.each {|item, attribute|
    checkout_total += attribute[:price] * attribute[:count]
  }
  if checkout_total > 100
    checkout_total = checkout_total - (checkout_total * 0.10)
  end
  checkout_total
end
