module TicketsHelper
  
  def simplier_paginated_section(*args, &block)
    pagination = will_paginate(*args).to_s
    "#{pagination}#{capture(&block)}#{pagination}"
  end
  
end
