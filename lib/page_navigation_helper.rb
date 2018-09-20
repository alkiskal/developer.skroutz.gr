module PageNavigationHelper
  # Constructs the relative url of a given inner Doc page
  #
  # @param [String] doc_base_url the base url of the Doc
  # @param [Hash] page the Doc page data
  # @return [String] the relative url to the Doc page
  def url_to_doc_page(doc_base_url, page)
    if page.url.nil?
      "#{site_url}/#{doc_base_url}#{page.title}/"
    else
      "#{site_url}#{page.url}"
    end
  end

  # Returns proper CSS classes if given Doc is the currently visited
  #
  # @param [String] doc the Doc to check if is active
  # @return [String] the active CSS classes
  def active_parent_link(doc)
    'active in' if current_page.url =~ /#{Regexp.quote(doc[:base])}/
  end

  # Returns proper CSS classes if given Page Doc is the currently visited
  #
  # @param [String] doc_page_url the Doc page url to check if is active
  # @return [String] the active CSS classes
  def active_child_link(doc_page_url)
    'active' if doc_page_url == current_page.url
  end

  # Builds a Doc parent link for Sidebar
  #
  # @param [String] key the docs key in data/docs.yml
  # @param [Hash] doc the doc data
  # @return [String] the html anchor element
  def sidebar_parent_link(key, doc)
    html = "<a class='collapse-btn #{active_parent_link(doc)}' "
    html << "data-toggle='collapse' data-parent='.nav-sidebar' "
    html << "href='#nav-sidebar-#{key}'>"
    html << "#{doc.title}"
    html << "<span class='label label-default pull-right'>deprecated</span>" if deprecated?(doc)
    html << "</a>"

    html
  end

  # Builds a Doc child page link for Sidebar
  #
  # @param [String] doc_key the docs key in data/docs.yml
  # @param [Hash] doc the doc data
  # @param [Hash] page the doc page data
  # @return [String] the html anchor element
  def sidebar_child_link(doc_key, doc, page)
    page_url = url_to_doc_page(doc.base, page)

    html = "<a class='navbar-link #{active_child_link(page_url)}' "
    html << "href='#{page_url}'>"
    html << "#{page.title.capitalize}"
    html << "</a>"

    html
  end

  # Returns a link to edit source on GitHub repo
  #
  # @return [String] the html anchor element
  def edit_link
    url = current_page.source_file.sub(/^(.*)\/source/,
      "#{settings.github_profile}/developer.skroutz.gr/blob/master/source")

    link_to "<span>Edit the file on GitHub</span>", url,
            title: "Edit the file on GitHub", class: 'btn-edit-github'
  end

  # Builds a Bootstrap List component for a given list of items.
  #
  # @param [Array] list_items the array of items
  # @param [String] list_classes the CSS classes to style the list
  # @return [String] the constructed <ul/> element
  def bs_list(list_items, list_classes)
    html = "<ul class='#{list_classes}'>"

    list_items.each do |list_item|
      html << '<li'
      html << ' class="active"' if list_item[:active]
      html << '>'
      html << list_item[:html]
      html << '</li>'
    end

    html << '</ul>'
    html
  end

  # Builds a Bootstrap Dropdown component for a given list of items.
  #
  # @param [Array] list_items the array of items
  # @param [String] list_classes the CSS classes to style the list
  # @param [String] dropdown_classes the CSS classes to style the dropdown
  # @param [String] toggle the dropdown toggle content
  # @return [String] the constructed <ul/> element
  def bs_dropdown(list_items, list_classes, dropdown_classes, toggle)
    html = "<ul class='nav navbar-nav #{list_classes}'>"
    html << "<li class='dropdown #{dropdown_classes}'>"
    html << '<a class="dropdown-toggle" data-toggle="dropdown" href="#">'
    html << toggle
    html << '</a>'
    html << '<ul class="dropdown-menu" role="menu">'

    list_items.each do |list_item|
      html << '<li'
      html << ' class="active"' if list_item[:active]
      html << '>'
      html << list_item[:html]
      html << '</li>'
    end

    html << '</ul></li></ul>'
    html
  end
end
