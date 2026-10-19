Rails.application.routes.draw do
  root "tax_calculations#index"
  
  post "tax_calculations", to: "tax_calculations#create"
end
