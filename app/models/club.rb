# frozen_string_literal: true

class Club < ApplicationRecord
  def as_json(options = {})
    super(options.merge(
      only: [
        :id,
        :name,
        :location,
        :representative_name,
        :email,
        :site_url,
        :x_url,
        :is_official
      ]
    ))
  end
end
