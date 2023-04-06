<nav class="navbar navbar-default navbar-fixed-top navbar-agid">

	<div class="container">

		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                            data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="<%=request.getContextPath()%>" style="margin-top: -15px;">
					<img src="images/agid-logo.png" style="margin:10px" alt="AGID">
					</a>
				</div>

				<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
					<ul class="nav navbar-nav">
						<li class="btn-group" id="peppol-bis">
							<button type="button" class="btn btn-primary btn-agid" style="margin-top: 8px;">Peppol BIS 3 Fatturazione</button>
							<button type="button" class="btn btn-primary dropdown-toggle btn-agid dropdown-alignment" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="margin-top: 8px;">
								<span class="caret"></span>
								<span class="sr-only">Toggle Dropdown</span>
							</button>
							<ul class="dropdown-menu">
								<li>
									<a href="<%=request.getContextPath()%>/my_index_fatt.jsp">Peppol BIS 3 Fatturazione</a>
									</li>
									<li>
										<a href="<%=request.getContextPath()%>/my_index.jsp">Peppol BIS 3 (altri processi)</a>
										</li>
									</ul>
								</li>

								<li class="dropdown">
									<a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Sintassi <span class="caret"></span>
									</a>
									<%@include file="../peppol-bis-invoice-3-ITA/menu/syntax-menu.html" %>
								</li>

								<li class="dropdown">
									<a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Regole <span class="caret"></span>
									</a>
									<%@include file="../peppol-bis-invoice-3-ITA/menu/rule-menu.html" %>
								</li>

								<li class="dropdown">
									<a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Codifiche <span class="caret"></span>
									</a>
									<%@include file="../peppol-bis-invoice-3-ITA/menu/codelist-menu.html" %>

								</li>

								<li class="dropdown dropdown-agid">
									<a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Fogli di stile <span class="caret"></span>
									</a>
									<%@include file="../peppol-bis-invoice-3-ITA/menu/stylesheet-menu.html" %>
								</li>

								<li class="dropdown dropdown-agid">
									<a href="https://peppol-validator.agid.gov.it/" class="dropdown-toggle link-agid" target="_blank" role="button" title="Piattaforma di Validazione Peppol (apre un link in nuova finestra)">
										Validatore
									</a>
								</li>

								<li class="dropdown dropdown-agid">
									<a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">IT<span class="caret"></span>
									</a>
									<ul class="dropdown-menu">
										<li><a href="<%=request.getContextPath()%>/my_index_fatt.jsp">IT</a></li>
										<li><a href="<%=request.getContextPath()%>/my_index_fatt-ENG.jsp">EN</a></li>
									</ul>
								</li>

							</ul>
						</div>
					</div>
				</nav>
