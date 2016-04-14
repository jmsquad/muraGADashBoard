
<!--- This file expects and iterator to be present named "pagerIT" --->

<cfparam name="rc.sortColumn" default="" />
<cfparam name="rc.sortDirection" default="" />
<cfparam name="rc.keyword" default="" />

<cfif pagerIT.getPageIndex() eq 1>
	<cfset startRow = 1>
<cfelse>
	<cfset startRow = (pagerIT.getPageIndex() * pagerIT.getNextN() ) +1 - pagerIT.getNextN() />
</cfif>

<cfset endRow = startRow + pagerIT.getNextN() -1>
<cfif endRow gt pagerIT.recordCount()>
	<cfset endRow = pagerIT.recordCount() >
</cfif>

<cfset sortURLStuff="&sortColumn=#rc.sortColumn#&sortDirection=#rc.sortDirection#&keyword=#rc.keyword#">
<cfoutput>
<div class="clearfix mura-results-wrapper">
	<p class="search-showing">
		Showing #startRow#-#endRow#
	</p>
	<div class="pagination">
		<ul class="moreResults">
			<cfif pagerIT.getPageIndex() gt 1>
				<li>
					<a href="#buildUrl(action=rc.action,queryString="page=#pagerIT.getPageIndex()-1##sortURLStuff#")#">&laquo;&nbsp;Prev</a>
				</li>
				<cfloop from="10" to="1" step="-1" index="i">
					<cfif pagerIT.getPageIndex() - i gt 0>
						<li>
							<a href="#buildUrl(action=rc.action,queryString="page=#pagerIT.getPageIndex()-i##sortURLStuff#")#">#pagerIT.getPageIndex()-i#</a>
						</li>
					</cfif>
				</cfloop>
			</cfif>
			<cfif pagerIT.pageCount() gt 1>
				<li>
					<a class="active" href="#buildUrl(action=rc.action,queryString="page=#pagerIT.getPageIndex()##sortURLStuff#")#">#pagerIT.getPageIndex()#</a>
				</li>
			</cfif>
			<cfif pagerIT.getPageIndex() lt pagerIT.pageCount()>
				<cfloop from="1" to="10" index="i">
					<cfif pagerIT.getPageIndex() + i lte pagerIT.pageCount()>
						<li>
							<a href="#buildUrl(action=rc.action,queryString="page=#pagerIT.getPageIndex()+i##sortURLStuff#")#">#i+pagerIT.getPageIndex()#</a>
						</li>
					</cfif>
				</cfloop>
				<li>
					<a href="#buildUrl(action=rc.action,queryString="page=#pagerIT.getPageIndex()+1##sortURLStuff#")#" >Next&nbsp;&raquo;</a>
				</li>
			</cfif>
		</ul>
	</div>
</div>
</cfoutput>
