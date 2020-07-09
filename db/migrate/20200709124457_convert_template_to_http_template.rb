class ConvertTemplateToHttpTemplate < ActiveRecord::Migration[6.0]
  def up
    Tempr.all.each do |tempr|
      next if tempr[:template].blank?

      http_template = HttpTemplate.create!(
        host: tempr[:template][:host],
        port: tempr[:template][:port],
        path: tempr[:template][:path],
        request_method:
          tempr[:template][:request_method] || tempr[:template][:requestMethod],
        protocol: tempr[:template][:protocol],
        headers: tempr[:template][:headers],
        body: tempr[:template][:body]
      )

      tempr.update_attribute(:templateable, http_template)
    end
  end

  def down; end
end
