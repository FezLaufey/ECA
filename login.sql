PGDMP                         |            login    12.18    12.18 (    5           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            6           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            7           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            8           1262    16393    login    DATABASE     �   CREATE DATABASE login WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_Malaysia.1252' LC_CTYPE = 'English_Malaysia.1252';
    DROP DATABASE login;
                postgres    false            �            1259    16456    devices    TABLE       CREATE TABLE public.devices (
    id integer NOT NULL,
    dname character varying(255) NOT NULL,
    avg_power numeric(10,2) NOT NULL,
    estimated_cost numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    user_id integer
);
    DROP TABLE public.devices;
       public         heap    postgres    false            �            1259    16454    devices_id_seq    SEQUENCE     �   CREATE SEQUENCE public.devices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.devices_id_seq;
       public          postgres    false    211            9           0    0    devices_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.devices_id_seq OWNED BY public.devices.id;
          public          postgres    false    210            �            1259    16429    readings    TABLE     �   CREATE TABLE public.readings (
    id integer NOT NULL,
    voltage double precision NOT NULL,
    current double precision NOT NULL,
    power double precision NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.readings;
       public         heap    postgres    false            �            1259    16427    readings_id_seq    SEQUENCE     �   CREATE SEQUENCE public.readings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.readings_id_seq;
       public          postgres    false    209            :           0    0    readings_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.readings_id_seq OWNED BY public.readings.id;
          public          postgres    false    208            �            1259    16412 
   speed_data    TABLE     �   CREATE TABLE public.speed_data (
    id integer NOT NULL,
    "timestamp" timestamp with time zone,
    speed double precision
);
    DROP TABLE public.speed_data;
       public         heap    postgres    false            �            1259    16410    speed_data_id_seq    SEQUENCE     �   CREATE SEQUENCE public.speed_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.speed_data_id_seq;
       public          postgres    false    205            ;           0    0    speed_data_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.speed_data_id_seq OWNED BY public.speed_data.id;
          public          postgres    false    204            �            1259    16396    users    TABLE     �   CREATE TABLE public.users (
    uid integer NOT NULL,
    username character varying(50),
    password character varying(50),
    reset_token character varying(255),
    reset_token_expiration timestamp with time zone,
    email character varying(255)
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16394    users_uid_seq    SEQUENCE     �   CREATE SEQUENCE public.users_uid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.users_uid_seq;
       public          postgres    false    203            <           0    0    users_uid_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.users_uid_seq OWNED BY public.users.uid;
          public          postgres    false    202            �            1259    16420    voltage_readings    TABLE     �   CREATE TABLE public.voltage_readings (
    id integer NOT NULL,
    voltage double precision NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now()
);
 $   DROP TABLE public.voltage_readings;
       public         heap    postgres    false            �            1259    16418    voltage_readings_id_seq    SEQUENCE     �   CREATE SEQUENCE public.voltage_readings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.voltage_readings_id_seq;
       public          postgres    false    207            =           0    0    voltage_readings_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.voltage_readings_id_seq OWNED BY public.voltage_readings.id;
          public          postgres    false    206            �
           2604    16459 
   devices id    DEFAULT     h   ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);
 9   ALTER TABLE public.devices ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210    211            �
           2604    16432    readings id    DEFAULT     j   ALTER TABLE ONLY public.readings ALTER COLUMN id SET DEFAULT nextval('public.readings_id_seq'::regclass);
 :   ALTER TABLE public.readings ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    208    209    209            �
           2604    16415    speed_data id    DEFAULT     n   ALTER TABLE ONLY public.speed_data ALTER COLUMN id SET DEFAULT nextval('public.speed_data_id_seq'::regclass);
 <   ALTER TABLE public.speed_data ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204    205            �
           2604    16399 	   users uid    DEFAULT     f   ALTER TABLE ONLY public.users ALTER COLUMN uid SET DEFAULT nextval('public.users_uid_seq'::regclass);
 8   ALTER TABLE public.users ALTER COLUMN uid DROP DEFAULT;
       public          postgres    false    203    202    203            �
           2604    16423    voltage_readings id    DEFAULT     z   ALTER TABLE ONLY public.voltage_readings ALTER COLUMN id SET DEFAULT nextval('public.voltage_readings_id_seq'::regclass);
 B   ALTER TABLE public.voltage_readings ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    206    207    207            2          0    16456    devices 
   TABLE DATA           \   COPY public.devices (id, dname, avg_power, estimated_cost, created_at, user_id) FROM stdin;
    public          postgres    false    211   �+       0          0    16429    readings 
   TABLE DATA           L   COPY public.readings (id, voltage, current, power, "timestamp") FROM stdin;
    public          postgres    false    209   �,       ,          0    16412 
   speed_data 
   TABLE DATA           <   COPY public.speed_data (id, "timestamp", speed) FROM stdin;
    public          postgres    false    205   �E       *          0    16396    users 
   TABLE DATA           d   COPY public.users (uid, username, password, reset_token, reset_token_expiration, email) FROM stdin;
    public          postgres    false    203   �L       .          0    16420    voltage_readings 
   TABLE DATA           D   COPY public.voltage_readings (id, voltage, "timestamp") FROM stdin;
    public          postgres    false    207   DM       >           0    0    devices_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.devices_id_seq', 24, true);
          public          postgres    false    210            ?           0    0    readings_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.readings_id_seq', 2181, true);
          public          postgres    false    208            @           0    0    speed_data_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.speed_data_id_seq', 94, true);
          public          postgres    false    204            A           0    0    users_uid_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_uid_seq', 7, true);
          public          postgres    false    202            B           0    0    voltage_readings_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.voltage_readings_id_seq', 1, true);
          public          postgres    false    206            �
           2606    16462    devices devices_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.devices DROP CONSTRAINT devices_pkey;
       public            postgres    false    211            �
           2606    16435    readings readings_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.readings
    ADD CONSTRAINT readings_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.readings DROP CONSTRAINT readings_pkey;
       public            postgres    false    209            �
           2606    16417    speed_data speed_data_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.speed_data
    ADD CONSTRAINT speed_data_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.speed_data DROP CONSTRAINT speed_data_pkey;
       public            postgres    false    205            �
           2606    16401    users users_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    203            �
           2606    16426 &   voltage_readings voltage_readings_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.voltage_readings
    ADD CONSTRAINT voltage_readings_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.voltage_readings DROP CONSTRAINT voltage_readings_pkey;
       public            postgres    false    207            �
           2606    24628    devices devices_user_id_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(uid);
 F   ALTER TABLE ONLY public.devices DROP CONSTRAINT devices_user_id_fkey;
       public          postgres    false    203    211    2721            2     x�}пJA�z�)�n���s�9�HrR�	(1����^��ͱS�o�SX/׷0H�
Bb=垭#��2����a����&���;�2�ꊡ6h� �fڍ��|���,^����	���P�Tz⎤�U2�(�oh�����!�7����r�DX�-$1�z����>���V�i�8�i;.��(J��8��Kւm׶Ŀ[D*�q$bgȉ3\[ŝ��(s��
�+y�h!*.3��%Q*)R1ϳ8`J��e      0      x��\k�)��ݳ�o� ������ffu��y�!�11aW!%)���̏پ���W-vt�Ui�O�?����o��������h� "��р��Z$�F#��Qf���� I�@D��c�!���hYb��h��5�̬�؆�Ɔ�@�� W����n��7i�����H R���l%{d�e�c���Q��`�|c��y��5!�ѱA����o��}-,�$�7l�T��	��1�I����!�V�E���i�F&�o�^د�µ^�F�z�.�xW+���z�)1�v�q^;־2�g�1��,;��l$'2�5k[7��=�Z28��چ%�퀴ъ �~a�E����nV٭�6,��\,I6���$ H���4[/���5�Q�4��q�cފ�J��] �X���*f�0��e���$Ķ ��Q�Ɓx�7��ǂ�1~�7����%ə������*W��p�ޱ'�R��<�ƒt,�r�[?!}���Q�� b�[8���,κ\����e?��nh�~��p�[=�$�F�&��3¥�u��N_S�,O�u�s2zj�8ހTBbN�I@�~���p	�!���o��>	��"~	gJO��vG���Z���Q�-�n@pףZ��Vlg����m���X`������1�AS��19���H������n�(ͱ�`�jwa|+��3��˱ܐ�TBJ��X�o@x�E�~Ͳш��h"N�\�@`�p�i�sy	� �]����"����	�VzC�ֲq{ͱ1^��W.yN������M	Ș�pb�~>��x@���QZ"D���!�_4��p?���r������dX���͂��N��R��	� �aQ�V~|���V���0.F��E#d\ X-��> �iJ���������CpA�¨�u��EB���b_������c�Oޭ0U���;�a�
H���  ��W�a�����m�C���L!�������=� �E�{����X��=��QEL�#�W�� �8F���A�l�1����>�0�Օ�Ǽ�Xd-o]�\�Xt�@<�T�-�_�w�>t$&��c�������ؿ��V?��1����b1��@�;�~�h*�7�ח_o_�K���dn����y=>G?kO�3��I�H�}���;s#tt.�Z��{:�Ѭ&��� ��vq.H��>����#�r�ipc������!���@2H������m�j���f�����}��g�H������tl�����-��}]6�41�#������kO����a&hDEHN�û������#�2X�\�O�Io��hB�Hb�]u����� �8}:���h��7+���%?N�E:e��kE3;
O�?69���Ԝ���x��n�Q=�}����XA���2l���n�mL����XFx��Τ��:�l!cH�Is�e�O�����Z�`� ��|��,�o�> �Y�E#eUˆ���[T!v�Z9XD�]TZ�0�*�5J�<�+XI�C�!��j��~�V+��1����uf%�'ᑄ�-�1
YBbb�̌Nn(lc�B9q���!���Z6bk7�!sR��F+Ӟx�`���A�Vb�s��AV�Z �!����&YQ�?��H%dT���Lb������$9�#][I�6������ʌĚ!d����b�	�7��������Z�GA6��4����e��	��tcB6�>�v�t� ���U���pI$�������zn�V�;�ucb�����l}}N ��xY-e�|�@�9&�xY)�D���J��}M��q�z�Oƣb�7V $l+p���t�`��WO2��q�xa��G��w�gnK@�I�?��;��IΣb>��{^��;hB6��;���1���L2$&/�"����%6>4$:��H۝1NR��D���� �}��jeg�%m��N���1��>Љ����L�*ey���$��F�n�J��aJ2Iwu.|��m8��l����E�6R�ƌ�奦 le���ts|G?;��NyG���+@&��AR���I�J��"������͂D S���,o���6tz�/W�0���w��4�\�p>���F�ƻ��/}g��;�5ձ�ݼ �����x�������6z�N�S;�7�W@��B��nmܡ ��x��9-Y���p��<�Xx��1^�����<W�x�`ul����IA0b�ݓ�+6�*0r��	�e� ���"�@fx>�a2yq�g[H�ak9��S��/�I7��|���<�u(�@������x���f�-�9.\�iJ����E?G5�v����9��"����{��B�d�J��� �3�������,��^/̉�H���%���rt2�*�~�����VtF\�?�;.��)�m"u �A�!���J��H>���҃�Ҫ�/�'S[f5��cŪ!>G�p�y���g�<��(K#��V�ư���y��_n1��;vDU��}	R��U|��iʠs�l��G�Ro�g��0�^��Iaeca��K�>��)�.�SV˒-�eg"��WS�`�9qR�}e0�pc�L�X6`�s�6��Fb,m8���̶Ռ���΍Y�����;���Hs�K�yt�:p�׺���K]A�����K�)ڷbAp@�X<I�#�&j��`g��#'_�]Ϥ��{��7sTn А4��翝��k�)�(������� q%�o�k��pD�a���@�ؑa3����*͂8x�O�`}㬪�{Glh�����#v�k�
v�YD��ex
Hgǐ�t���-_�ԱΎM�![v���c1�I��!��Npi�\�&'�b��l���`*s4o�r�9G~ah^fn��s��Xt�A���mHм�.��h$��S7b�K�D�<��Tw懎��mL���mm��LA6�6y"��k^*ԍVt��z�m���t�Z4�Q�JA!����h���t/�°�-f�c�c��`��6B�Ԉ�B�:Øl�b�7F�\�z�R������A]/��d�f�89�w1vnn&�Æ�կ��L$����`��8�Z?���6� 5[p�c��.4�Kq�2w��J��+�㣈��&�}n,�NƄ~j��� �j:<>/nrc&il%uo�+�2�h���;[����EO�r��q�ܒ�'���A��ĥD�m���SW�^˔n|�(�J���m�F%yC���K�8��1𺾎����1�H`~�9�$�e���R��T[o�� Ɇ%�V�Ʀdp��dcSҘ>"�����cF@�א)sI≈wR۽�a��%y��\�Yv\��TQ0� $W&]3E��")���D���7q�O�V7"��	)^�$״�>�ܪdlb�l��d��1	$����Z��i�:��#=B�F�����!>+�B8���ND$��i0I�y�
oŭS�>D��W���􆐴��u�
˅+D#1^rۓ+$��q�/?�#'Wx<�	�`�C�����7�(ɠ#�d�Z�%��$�����uj���Z�M�S��,MT�=ؿh"I�#9�UE��N)���}��/D��� *��L �a��l�?�Ѓ��G��Y��c,x^�c�YGI�/.D>E��Fm9�Nx8VD���=���zƒ���D�ɝ--P���6х+2/7G�F*����Q7���ad�VY�+.�i���B��%��x2�ɱGu������&M`�5�F�=6�K�:��S�:K�n�ʴ�X�rb5H�ws�Ѥ�yUğ�P(�z�y��g!�a�<��>�� P��,O!������W�/�d�M����?��$�;]�a
kErԱ��UG1�Q�Um��b-"p�����]/��M�*��Ff�����'ñ�� ��"� ��t�u�I��C	�S�r�#3�yj��F<ݴ��-�j��%����P;¹r*3�U�;�gQ����1�le�������6�^��fU6�T*v�1�ٽ#�T+e���,&[�Sݤ�d}�����f� �p&-�"���;6�6�F���� �  :s��xZ5�}#�0���,���c�`*͡�f֗ѱ ��8��X�QZS�և7��3�"T'�ԉ�0�;���Bcn,KF1�[ؤ�O��Ͳd�<��轂��Zaa���BﲱƺI69Z?U��T�3����������9��4uI1j����"�'\R��v�ܢ˓�Y����~�r��9El8K�O��P�6�NǪj����������ޘO��2Q	��p�S��TOI�W ��~^��'͍HVGw?+xz	��
�{+!���8�41H!`˟�Nl,FR�4�Ee��_�����u�� ��w\(;%�<��T)�g4� 1(�V$�->���(��q�.!TY^�t$ЈIe��Nkg��"��ހ�(��k�5�/�1j�tiw��M%�-�أ���� _*�
�4�-�>E�t����B���4"i(�+CAk�%y&���R�_W��F^��r6,!�sb��|@Pf7�!i��xWK�tqRl��5��L�oI^;����dP�	MA��Q�Y�|a��QK�:�ib�t��⛒���;��Ņ ����&D��F���rS�Eլ�R�h/�j'�qmS+Hȥ,���v�%�:ad�Cݺ����{֧���h�TD)ײ�;]�J�GoU�r� ��e�[�$9C@\8�[BO��A)z��bO)�>!�0��Rw�e�D�R^�����'�"	��Fu?߽B+���a��g#��hl�FS-�BV�'E?�4 ���9����>Xw��p�~J��E��_�Y_ �����}��"�����ˡ ����to�W
s�F�"6B�'>|_��<IK��O]�Fg��_Qh]�Fy[a�/R�NϤ�D,'��4��I$��J��X��|#b`Ī�4�0���Fy[�������Z��H��0^N��Z�'�~I1v=A��t�s�>IM�F��\6�:Ҋw�G9W�u1|(ח��a�bu�ye�!��I#�▩u��Xò�H�wV��Hxv�^���Uwϴ�⹋��D2��sԿR�0�AF�{^/�N�\��A�������/���}
��;/�%���Q�"<�,�]��e�#��ۈZX�D�Нp��)��E`g���<H���T��*"gR��6>W�+Q�Z��`}	P��0H܍ܡ:]��^��ڸ;oC�$�gHd�#d���H��,i��CD[v�9���uc�4v���U���
p�#�+�N�mh�L��Q\����Y���8���J�~�ruуHI�ψ��� �|��IV�,�\������w�_C�s��Cqߎ�+��j0�,��qGO�pݻ����1�;B5Ɏv�dq�ӱ����<DBn�7���I92�F;�`c�b��kG��z@:��eb1�X��QX�9@p�j�wގ��N��'m\@��8ɰ)��χ}�K�;mg��ya5U-8��G��G�ĉ��D�vF,��_�$��T�i[�0��&%�E�Ӧ��&�핉Л��͝M�Ѓڤ�)�d����9e}lV/�O��멷�L��@=�L;�j-)e���\:��p|zhu�Z��FG���{AбA"�K�!��Z�W>��eU�L&	5�fx�s�[�lK�"6��H�x%�k����Y��2T��SU�zpr ���/,a�����\�W"��)��ԫ�x����~1Mz=r���FH;�/ױ ����ڠb�+����E���&�ǲW֡s&�Ϥ���EL���T�}�Q���FA�k�����w�:T_9�ꙿ��q��!R^d'��AR�M�����3�&%�����څǩ���鸳��0U�*-T{�8tf��L��v�Գz���j��4��N�hT <�x����*�����*l L��2���:��6%2{�	w"3ei�誹����0��č^t/�l5i���U���\ȶ���/cM>�K$5q����~V*W�́����S���Y����P���|�3�n�d�|1���b�&1�zYMX�=Q����m��t$��J�
�Պ��*|�v�`�jE�����z���n�#�S�]��7��Tf5z*�\?_D��,Bⲋ,�V��Z����;��|/�5��x�����/4�I����D���Z�}K�t�"��xm�y=�c��4U�/��oՙ���KN������+#%����QD�E������
q}��F��i�������+�}d,������������/�      ,     x�mX[�7��N���B�{���a��I���Ñ��bQ�����E�'�ˏ�.����ꏈ��&"����o�n|�:����*��!v;�7w�2p���o��|�*�]�s���C�[����+��M�3UW�������%��b?Dߐ�f��������!��D�a��*Y���Ď���A�@%�Ze���ڒ�u�?F������m������*F9��_�R|�$pb�ZP�X_�E�<8�CI�� �t
#r`�#]q��4iT�*'�bE8�9�z�GZ�F��Y/��ѥ�����tVt��;CT6.Q	���r;F6CX\��Ɍ�����FT�FP[J�����ۥ��TPdqM�����ߐȭ1mNhň�!����E�ö�Ac,@%�Jd2�,��ǏMA�����
��SÏ��aHF+Z#�GW���xb�v�U���)8���,jI�@ffȮINLY��tx%��%��@ɷ*����vku8Y�@�	a�1��GiNa(���Ak3��d���C��9~B�bq���Fi�5�K�	�9O-��l|t��[�/�ި��p��Š.��\�p/{�`)|���Ac0U�R�A��n�~�"�%h��K㎐c�0�<�R��1��m�-�B	[o{�S~`�Cs)Cj����\J�;�GU`ѺQ������\�����$xL8�,�S?��Y����h�F�ɚ��ě��{��vaoČ#>�0�ew�û����a�Yva�Q����n?*��g����4W���Ʒ'�+��z�(���.	T�O<�0\���ᗘ���.��(�3^��8f>S�b����/��;)a���+�Wy�	��E��e�
��a����� 
p�/�WH!L��2$�q���r~A�f	h���@
9ac��!���׀�]�T�Mb �����J9��LcF�F1��L��R;���2-@W�?�?t�.���4�\��������\���E
c����?�}S9���!$1��aҵ����`��%蒑�q1�/��
�s1��(�=�̊�b���W&�Eh6+!� ���`p�O�0��N����@���<l�0��RN5�$`&���ad�5��2��c&36+���d���� ��/����7 S��?{/��G��q�7�,��K��d���N$�7����3V�V:�W<Pȍ��U�Ibj���hƷbR)ľ�ᝅ�j-�KD���A<�SE�E,�`x vr�ȕ��A$��'.�8�$Ǭ��;�l^yNW����B̛O������=����8��9'����^0~6�5j؆h3�H@x ���`�a��|Vsf@F���+�	q��zyi-'�
]��se�!r�ℷ��P� ���P���c�d�j��3O%�w��&��Ѐ���~=�XNbv��9��U�LcDrټb�
0�U�I���KW���c��<4p0>a��&�%�	���yf�C���SB:�Ox��09��@�e^��9����'-���!��9��5�����2@�`L�8�])�dN��M ��^������ѦY���~���^ � ������%�;ab�~�����.Ff]� :� [M/����+��٩�V�+�Z�>e������Z��IM��kȠ�y�(���FBW���
Y/Uȱ3c~�����y.������o1&�".����4z���Z� P/��      *   y   x�3�LL���3�,H,..�/J1426�� .#�4'��1D�,l�7�,I-.ASlʙ����&h�鑘��Z�,��Y�Z�������쐞��������e��U�)�4#����I]� #7P      .      x������ � �     