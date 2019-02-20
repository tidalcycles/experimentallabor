(
// returns the created dirt instance
// assumes that the remote SuperDirt sclang application has a DirtRemoteSoundfileInfo running
// DirtRemoteSoundfileInfo(dirt.soundLibrary).start(langport);
~bootRemoteSuperDirt = { |ip, port = 57111, channels = 2, langport = 57120|
	var dirt, remoteLoader, langaddr;
	o = Server.local.options;
	o.numOutputBusChannels = channels;
	q = Server.remote(\remote, NetAddr(ip, port), o);
	langaddr = NetAddr(ip, langport);
	q.waitForBoot {
		dirt = SuperDirt(channels, q); // two output channels, increase if you want to pan across more channels
		dirt.removeModule(\envelope);
		remoteLoader = DirtRemoteSoundfileInfo(dirt.soundLibrary);
		remoteLoader.sendRequest(langaddr, { |buffers|
			buffers.pairsDo { |key, buffer|
				~lib.addBuffer(key, buffer, appendToExisting: true)
			}
		});
		dirt.start(langport, [0, 0]);
	};
	
	Server.default = q;
	q.latency = 0.5;
	dirt;
};
)
