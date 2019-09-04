FROM centos:7
MAINTAINER Petr Fedchenkov <giggsoff@gmail.com>

USER root

# add ceph repo
RUN yum install -y epel-release&&yum install -y centos-release-ceph-luminous&&\
yum install -y yum-utils rpm-build redhat-rpm-config make gcc libxslt docbook-style-xsl libaio-devel systemd-devel libibverbs-devel librdmacm-devel rados-objclass-devel librbd-devel glusterfs-api-devel
ADD scsi-target-utils-1.0.55-4.el7.src.rpm .
RUN rpm -i scsi-target-utils*.src.rpm && cd ~/rpmbuild && sed -ie 's/%{!?rhel:%global with_rbd 1}/%global with_rbd 1/' SPECS/scsi-target-utils.spec&&\
sed -ie 's/BuildRequires: ceph-devel/#BuildRequires: ceph-devel/' SPECS/scsi-target-utils.spec&&rpmbuild -ba SPECS/scsi-target-utils.spec&&\
yum install -y ./RPMS/aarch64/scsi-target-utils-1.*.rpm ./RPMS/aarch64/scsi-target-utils-rbd-1.*.rpm
EXPOSE 3260
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
