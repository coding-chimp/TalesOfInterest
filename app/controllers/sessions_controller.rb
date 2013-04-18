class SessionsController < Devise::SessionsController
	before_filter :standard_sidebar, :search
end