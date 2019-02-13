(
// returns the created dirt instance
~bootRemoteSuperDirt = { |ip, port = 57111, channels = 2|
  var dirt;
  o = Server.local.options;
  o.numOutputBusChannels = channels;
  q = Server.remote(\remote, NetAddr(ip, port), o);
  q.waitForBoot {
	dirt = SuperDirt(channels, q); // two output channels, increase if you want to pan across more channels
	dirt.addModule('envelope', {}, { false });
	//	~dirt.loadSoundFiles; // does not yet work
	q.sync; // wait for samples to be read
	dirt.start(57120, [0, 0]);   // start listening on port 57120, create two orbits, each sending audio to channel 0. You can direct sounds to the orbits from tidal e.g. by: `# orbit "0 1 1"
  };

  Server.default = q;
  q.latency = 0.5;
  dirt;
};
)