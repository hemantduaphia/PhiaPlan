component output="false" accessors="true" extends="PhiaPlan.org.Hibachi.HibachiSessionService"  {

	public void function setPropperSession() {
		super.setPropperSession();
		getHibachiScope().getSession().setUserAgent(cgi.HTTP_USER_AGENT);
	}
}