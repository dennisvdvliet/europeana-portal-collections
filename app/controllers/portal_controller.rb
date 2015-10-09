##
# Europeana portal controller
#
# The portal is an interface to the Europeana REST API, with search and
# browse functionality provided by {Blacklight}.
class PortalController < ApplicationController
  include Catalog
  include Europeana::Styleguide

  before_action :redirect_to_root, only: :index, unless: :has_search_parameters?

  # GET /record/:id
  def show
    @response, @document = fetch_with_hierarchy(doc_id)
    @mlt_response, @similar = more_like_this(@document, nil, per_page: 4)
    @debug = JSON.pretty_generate(@document.as_json) if params[:debug] == 'json'

    respond_to do |format|
      format.html do
        setup_next_and_previous_documents
        render action: 'show'
      end
      format.json { render json: { response: { document: @document } } }
      additional_export_formats(@document, format)
    end
  end

  # GET /record/:id/similar
  def similar
    _response, document = fetch(doc_id)
    @response, @similar = more_like_this(document, params[:mltf], per_page: params[:per_page] || 4)
    respond_to do |format|
      format.json { render :similar, layout: false }
    end
  end

  # GET /record/:id/media
  def media
    @response, @document = fetch(doc_id)
    @page = params[:page] || 1
    @per_page = params[:per_page] || 4

    respond_to do |format|
      format.json { render :media, layout: false }
    end
  end

  # GET /record/:id/hierarchy
  def hierarchy
    relation = params.key?(:relation) ? params[:relation].underscore : nil

    if relation.present?
      page = (params[:page] || 1).to_i
      per_page = (params[:per_page] || 4).to_i
      offset = (page == 1 ? 0 : (per_page * page) - 1)
      options = { limit: per_page, offset: offset }

      _response, @document = fetch(doc_id)
      @hierarchy = fetch_hierarchy_relation(doc_id, relation, options)
    else
      _response, @document = fetch_with_hierarchy(doc_id)
      @hierarchy = @document.hierarchy
    end

    respond_to do |format|
      format.json { render :hierarchy, layout: false }
    end
  end

  # @todo move into own controller to isolate record resource related actions
  def static
    @page = params[:page]
    respond_to do |format|
      format.html
    end
  end
end
