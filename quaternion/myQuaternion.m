classdef myQuaternion
    %QUATERNION Class to represent quaternion objects
    %Can store a single quaternion 
    %TODO: or a collection of them

    properties(Hidden)
        components = [0;0;0;0]; %As column 4-vector;
    end
    properties(Dependent)
        scalar %scalar part
        vector %3-vector part
    end

    methods
        function obj = myQuaternion(inputArg1,varargin) %CONSTRUCTOR
            if nargin == 1 %Assumed 4-vector
                if numel(inputArg1) ~= 4
                    error('')
                end
                obj.components = inputArg1(:);
            elseif nargin == 2 %Assumed scalar + vector part
                if numel(inputArg1)~=1 || numel(varargin{1})~=3
                    error('')
                end
                obj.components = [inputArg1;varargin{1}(:)];
            elseif nargin == 4
                if all(cellfun(@(x) numel(x),varargin) == 1) && numel(inputArg1)==1
                    obj.components = [inputArg1;varargin{1};varargin{2};varargin{3}];
                else
                    error('')
                end
            end
            if size(obj.components,1) ~= 4
                error('Fix the constructor!')
            end
        end

        function s = get.scalar(obj)
           s=obj.components(1);
        end

        function s = get.vector(obj)
           s=obj.components(2:4);
        end

        function q = mtimes(this,other)
            %Product in right-handed convention for quaternions (ij=k)
            q = myQuaternion([this.scalar * other.scalar - this.vector'*other.vector; ...
                 this.scalar * other.vector + other.scalar * this.vector + cross(this.vector,other.vector)]);
        end

        function q = conj(this)
            q = myQuaternion(this.scalar,-this.vector);
        end

        function n = norm(this)
            n = sqrt(sum(this.components.^2,1));
        end

        function q = plus(this,other)
            q = myQuaternion(this.components+other.components);
        end

        function q = inv(this)
            q = myQuaternion(this.conj.components/this.norm.^2);
        end

        function [w,J] = rotate(this, v)
            %Rotates vector v by quaternion
            %If given two outputs, also returns the Jacobian with respect
            %to the quaternion.  The Jacobian is taken WRT to each
            %component of the quaternion as a 4-vector.
            v=v(:); %To column
            w = this.mtimes(myQuaternion.fromVector(v)).mtimes(this.inv).vector;
            if nargout>1
                skewV = vec2skew(v);
                Jaux = 2*[this.scalar*v-skewV*this.vector,-this.scalar*skewV-v*this.vector'+this.vector'*v*eye(3)+this.vector*v'];
                %Jaux is the jacobian of f(q) = qvq*
                %J is the jacobian of g(q) = qvq^{-1} = f(q)/|q|^2
                J = (Jaux - 2*w*this.components')/this.norm.^2;
            end
        end

        function [w,J] = rotateinv(this, v)
            %Rotates vector v by quaternion
            %If given two outputs, also returns the Jacobian with respect
            %to the quaternion.  The Jacobian is taken WRT to each
            %component of the quaternion as a 4-vector.
            v=v(:); %To column
            w = this.inv.mtimes(myQuaternion.fromVector(v)).mtimes(this).vector;
            if nargout>1
                skewV = -vec2skew(v);
                Jaux = 2*[this.scalar*v-skewV*this.vector,-this.scalar*skewV-v*this.vector'+this.vector'*v*eye(3)+this.vector*v'];
                %Jaux is the jacobian of f(q) = q*vq
                %J is the jacobian of g(q) = q^{-1}vq = f(q)/|q|^2
                J = (Jaux - 2*w*this.components')/this.norm.^2;
            end
        end

        function v = to3Vector(this)
            if this.scalar~=0
                error('Not a pure quaternion, cannot cast as a 3-vector')
            else
                v=this.vector;
            end
        end

        function v = to4Vector(this)
            v=this.components;
        end

        function ML = toLeftProdMatrix(this)
            %Computes a matrix ML(q) such that for two quaternions q1 & q2:
            % q1*q2 =  ML(q1) * q2.to4Vector;
            ML = this.scalar*eye(4) + [0, -this.vector'; this.vector, vec2skew(this.vector)];
        end

        function MR = toRightProdMatrix(this)
            %Computes a matrix ML(q) such that for two quaternions q1 & q2:
            % q1 * q2 =  MR(q2) * q1.to4Vector;
            MR = this.scalar*eye(4) + [0, -this.vector'; this.vector, -vec2skew(this.vector)];
        end

        function R = toRotationMatrix(this)
            R = this.toLeftProdMatrix * this.inv.toRightProdMatrix;
            R = R(2:4,2:4);
        end

        function R = toRotationInvMatrix(this)
            R = this.toRotationMatrix';
        end
    end

    methods(Static)
        function obj = fromVector(v)
            %Creates a pure-quaternion from a 3-vector
            obj = myQuaternion(0,v);
        end
    end
end