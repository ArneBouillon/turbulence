module mod_usr
    use mod_hd
    use mod_viscosity

    implicit none
    double precision :: Reynolds
    double precision :: v0, rho0
    integer :: index1

contains
    subroutine usr_init()
        use mod_variables

        usr_set_parameters  => initglobaldata_usr
        usr_modify_output   => specialvar_output
        usr_init_one_grid   => initonegrid_usr
        usr_special_bc      => my_bounds
        usr_internal_bc     => my_internal_bounds
        !usr_add_aux_names  => specialvarnames_output
        usr_special_convert => do_nothing

        call hd_activate()
        call params_read(par_files)

        call set_coordinate_system('Cartesian_2D')

        index1 = var_set_extravar("curlV", "curlV")
    end subroutine usr_init

    subroutine params_read(files)
        character(len=*), intent(in) :: files(:)
        integer                      :: n

        namelist /my_list/ Reynolds

        do n = 1, size(files)
            open(unitpar, file=trim(files(n)), status="old")
            read(unitpar, my_list, end=111)
111         close(unitpar)
        end do

    end subroutine params_read

    subroutine initglobaldata_usr
        double precision :: vc_tau, Mach=1.d0
        v0     = one
        rho0   = one
        vc_mu  = 1.d0 / Reynolds
        vc_tau = one / vc_mu
        print*, '- - -'
        print*, 'Reynolds # ', Reynolds
        print*, 'The simulation duration has been set to ', time_max
        print*, '- - -'

        hd_adiab = one / Mach**two

        if (hd_energy) call mpistop("Blabla")

    end subroutine initglobaldata_usr

    subroutine initonegrid_usr(ixI^L,ixO^L,w,x)
        integer, intent(in) :: ixI^L, ixO^L
        double precision, intent(in) :: x(ixI^S,1:ndim)
        double precision, intent(inout) :: w(ixI^S,1:nw)

        w(ixO^S,rho_)   = rho0
        w(ixO^S,mom(1)) = zero
        w(ixO^S,mom(2)) = zero
    end subroutine initonegrid_usr

    ! Top boundary sheared, bottom fixed
    subroutine my_bounds(qt,ixG^L,ixB^L,iB,w,x)
        integer, intent(in) :: ixG^L, ixB^L, iB
        double precision, intent(in) :: qt, x(ixG^S,1:ndim)
        double precision, intent(inout) :: w(ixG^S,1:nw)
        integer :: i

        select case (iB)
        case(1) ! left continuous
            w(ixBmax1,:,rho_)   = w(ixBmax1+1,:,rho_)
            w(ixBmax1,:,mom(1)) = one ! w(ixBmax1+1,:,mom(1))
            w(ixBmax1,:,mom(2)) = zero !w(ixBmax1+1,:,mom(2))
            do i=ixBmin1,ixBmax1-1
                w(i,:,:)      = w(ixBmax1,:,:)
            enddo
        case(2) ! right no inflow
            w(ixBmin1,:,rho_)   = w(ixBmin1-1,:,rho_)
            where (w(ixBmin1-1,:,mom(1))>zero)
                w(ixBmin1,:,mom(1)) = w(ixBmin1-1,:,mom(1))
            elsewhere
                w(ixBmin1,:,mom(1)) = zero
            end where
            w(ixBmin1,:,mom(2)) = zero !w(ixBmin1-1,:,mom(2))
            do i=ixBmin1+1,ixBmax1
                w(i,:,:)      = w(ixBmin1,:,:)
            enddo
        case(3) ! bottom
            w(:,ixBmax2,rho_)   = w(:,ixBmax2+1,rho_) ! continuous
            w(:,ixBmax2,mom(1)) = w(:,ixBmax2+1,mom(1))
            w(:,ixBmax2,mom(2)) = zero
            do i=ixBmin2,ixBmax2-1
                w(:,i,:)      = w(:,ixBmax2,:)
            enddo
        case(4) ! top
            w(:,ixBmin2,rho_)   = w(:,ixBmin2-1,rho_) ! continuous
            w(:,ixBmin2,mom(1)) = w(:,ixBmin2-1,mom(1))
            w(:,ixBmin2,mom(2)) = zero
            do i=ixBmin2+1,ixBmax2
                w(:,i,:)      = w(:,ixBmin2,:)
            enddo
        case default
            call mpistop('BC not implemented')
        end select

    end subroutine my_bounds

    subroutine my_internal_bounds(level,qt,ixI^L,ixO^L,w,x)
        integer, intent(in) :: ixI^L,ixO^L,level
        double precision, intent(in) :: qt
        double precision, intent(inout) :: w(ixI^S,1:nw)
        double precision, intent(in) :: x(ixI^S,1:ndim)

        where (x(ixO^S,1) .lt. 8.5 .and. x(ixO^S,1) .gt. 7.5 .and. ((x(ixO^S,2) .lt. 12.5 .and. x(ixO^S,2) .gt. 11.5) .or. (x(ixO^S,2) .lt. 18.5 .and. x(ixO^S,2) .gt. 17.5)))
            w(ixO^S,rho_) = one
            w(ixO^S,mom(1)) = zero
            w(ixO^S,mom(2)) = zero
        end where

    end subroutine my_internal_bounds

    subroutine specialvar_output(ixI^L,ixO^L,qt, w,x)
        use mod_physics

        integer, intent(in)                :: ixI^L,ixO^L
        double precision, intent(in)       :: qt, x(ixI^S,1:ndim)
        double precision, intent(inout)    :: w(ixI^S,nw)
        double precision                   :: v(ixI^S,ndir), curlV(ixI^S)
        integer                            :: i
        integer                            :: idirmin,idir

        do i=1,ndir
            v(ixI^S,i)=w(ixI^S,mom(i))
        enddo
        call curlvector(v,ixI^L,ixO^L,curlV,idirmin,7-2*ndir,ndir)
        w(ixO^S,index1) = curlV(ixO^S)

    end subroutine specialvar_output

    subroutine do_nothing(qunitconvert)
        integer, intent(in) :: qunitconvert
    end subroutine do_nothing
end module mod_usr
