class ConvertTemplateToHttpTemplate < ActiveRecord::Migration[6.0]
  def up
    Tempr.all.each do |tempr|
      next if tempr[:template].blank?

      http_template = HttpTemplate.create!(
        host: {
          language: 'text',
          script: tempr[:template][:host]
        },
        port: {
          language: 'text',
          script: tempr[:template][:port]
        },
        path: {
          language: 'text',
          script: tempr[:template][:path]
        },
        request_method: {
          language: 'text',
          script:
            tempr[:template][:request_method] || tempr[:template][:requestMethod]
        },
        protocol: {
          language: 'text',
          script:tempr[:template][:protocol]
        },
        headers:
          (
            tempr[:template][:headers].present? &&
              {
                language: 'js',
                script: "module.exports = #{tempr[:template][:headers].to_json};"
              } ||
              {}
          ),
        body: tempr[:template][:body]
      )

      tempr.update_attribute(:templateable, http_template)
    end
  end

  def down; end
end
