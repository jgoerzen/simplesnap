Name:           simplesnap
Version:        %{?version}
Release:        %{?relversion}%{?dist}
Summary:        A simple and powerful way to send ZFS snapshots across a network
License:        GPLv2+
Group:          Applications/System
URL:            https://github.com/jgoerzen/%{name}
Source0:        %{name}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch
Requires:       liblockfile

%description
A simple and powerful way to send ZFS snapshots across a network

%prep
%setup -qn %{name}-%{version}

%build
# Do nothing

%install
rm -rf $RPM_BUILD_ROOT

make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc README.txt INSTALL.txt TODO COPYING examples
%attr(0755, root, root) %{_sbindir}/simplesnap
%attr(0755, root, root) %{_sbindir}/simplesnapwrap
%{_mandir}/man8/simplesnap.8.gz

%changelog
* Thu Jul 24 2014 Trey Dockendorf <treydock@gmail.com> %{version}
- Initial spec file creation
