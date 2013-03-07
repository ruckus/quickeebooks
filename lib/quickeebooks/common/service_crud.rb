module ServiceCRUD

  def create(object)
    raise InvalidModelException unless object.valid?
    xml = object.to_xml_ns
    response = do_http_post(url_for_resource(model.resource_for_singular), valid_xml_document(xml))
    if response.code.to_i == 200
      model.from_xml(response.body)
    else
      nil
    end
  end

  def fetch_by_id(id)
    url = "#{url_for_resource(model.resource_for_singular)}/#{id}"
    response = do_http_get(url)
    if response && response.code.to_i == 200
      model.from_xml(response.body)
    else
      nil
    end
  end

  def update(object)
    raise InvalidModelException.new("Missing required parameters for update") unless object.valid_for_update?
    url = action_url(object)
    xml = object.to_xml_ns
    response = do_http_post(url, valid_xml_document(xml))
    if response.code.to_i == 200
      model.from_xml(response.body)
    else
      nil
    end
  end

  def delete(object)
    raise InvalidModelException.new("Missing required parameters for delete") unless object.valid_for_deletion?
    xml = valid_xml_document(object.to_xml_ns(:fields => ['Id', 'SyncToken']))
    url = action_url(object)
    response = do_http_post(url, xml, {:methodx => "delete"})
    response.code.to_i == 200
  end

  def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
    fetch_collection(model, filters, page, per_page, sort, options)
  end

  def model
    self.class.to_s.sub(/::Service::/,'::Model::').constantize
  end

  def action_url(object)
    url = "#{url_for_resource(model.resource_for_singular)}/#{object.id.value}"
  end

end
